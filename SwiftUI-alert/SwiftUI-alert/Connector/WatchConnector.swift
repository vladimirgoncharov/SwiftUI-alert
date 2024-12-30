import Foundation
import Combine
import WatchConnectivity

@MainActor
final class WatchConnector: NSObject {
    private let session = WCSession.default
    
    private let namePublished = PassthroughSubject<String?, Never>()
    var namePublisher: AnyPublisher<String?, Never> {
        namePublished.eraseToAnyPublisher()
    }
         
    override init() {
        super.init()

        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
}

// MARK: - WCSessionDelegate

extension WatchConnector: WCSessionDelegate {
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
    }
    
    nonisolated func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        let name = userInfo["name"] as? String
        Task { @MainActor [weak self, name] in
            self?.dataReceivedFromWatch(name: name)
        }
    }
    
    // MARK: use this for testing in simulator
    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let name = message["name"] as? String
        Task { @MainActor [weak self, name] in
            self?.dataReceivedFromWatch(name: name)
        }
    }
}

// MARK: - ConnectorProtocol

extension WatchConnector: ConnectorProtocol {
    func sendData(authState: AuthState) {
        let name = AuthStatePresenter(authState: authState).name
        var data: [String : Any] = [:]
        if let name {
            data["name"] = name
        }
        session.sendMessage(data, replyHandler: nil)
    }
}

// MARK: - receive data

private extension WatchConnector {
    func dataReceivedFromWatch(name: String?) {
        namePublished.send(name)
    }
}
