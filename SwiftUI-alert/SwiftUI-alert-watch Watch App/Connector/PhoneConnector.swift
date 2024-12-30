import Foundation
import Combine
import WatchConnectivity

@MainActor
final class PhoneConnector: NSObject {
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

extension PhoneConnector: WCSessionDelegate {
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
    }
    
    nonisolated func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        let name = userInfo["name"] as? String
        Task { @MainActor [weak self, name] in
            self?.dataReceivedFromPhone(name: name)
        }
    }
    
    // MARK: use this for testing in simulator
    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let name = message["name"] as? String
        Task { @MainActor [weak self, name] in
            self?.dataReceivedFromPhone(name: name)
        }
    }
}

// MARK: - ConnectorProtocol

extension PhoneConnector: ConnectorProtocol {
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

private extension PhoneConnector {
    func dataReceivedFromPhone(name: String?) {
        namePublished.send(name)
    }
}
