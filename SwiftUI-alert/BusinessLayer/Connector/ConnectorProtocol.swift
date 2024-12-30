import Foundation
import Combine

@MainActor
protocol ConnectorProtocol: NSObjectProtocol, Sendable {
    var namePublisher: AnyPublisher<String?, Never> { get }

    func sendData(authState: AuthState)
}
