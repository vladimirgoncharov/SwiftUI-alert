import Foundation
import Combine

@MainActor
final class AuthServiceImpl: AuthServiceProtocol {
    private let connector: (any ConnectorProtocol)
    
#if os(watchOS)
    private var cancellables = Set<AnyCancellable>()
#endif
    
    private let authStatePublished = CurrentValueSubject<AuthState, Never>(.unauthorized)
    var authStatePublisher: AnyPublisher<AuthState, Never> {
        authStatePublished.eraseToAnyPublisher()
    }
    var authState: AuthState {
        authStatePublished.value
    }
    
    init(connector: (any ConnectorProtocol)) {
        self.connector = connector
        
#if os(watchOS)
        connector.namePublisher.sink { [weak self] name in
            if let name {
                self?.singIn(name: name)
            } else {
                self?.logout()
            }
        }.store(in: &cancellables)
#endif
    }
    
    func singIn(name: String) {
        let authState = AuthState.authorized(name: name)
        authStatePublished.send(authState)
        connector.sendData(authState: authState)
    }
    
    func logout() {
        let authState = AuthState.unauthorized
        authStatePublished.send(authState)
        connector.sendData(authState: authState)
    }
}
