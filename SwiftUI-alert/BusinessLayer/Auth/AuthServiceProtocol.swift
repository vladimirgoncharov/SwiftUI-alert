import Foundation
import Combine

@MainActor
protocol AuthServiceProtocol: Sendable {
    var authStatePublisher: AnyPublisher<AuthState, Never> { get }
    var authState: AuthState { get }
    
    func singIn(name: String)
    func logout()
}
