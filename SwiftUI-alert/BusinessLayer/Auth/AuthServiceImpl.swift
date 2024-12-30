import Foundation
import Combine

@MainActor
final class AuthServiceImpl: AuthServiceProtocol {
    private let connector: (any ConnectorProtocol)
    
    private var cancellables = Set<AnyCancellable>()
    
    private let authStatePublished = CurrentValueSubject<AuthState, Never>(.unauthorized)
    var authStatePublisher: AnyPublisher<AuthState, Never> {
        authStatePublished.eraseToAnyPublisher()
    }
    var authState: AuthState {
        authStatePublished.value
    }
    
    init(connector: (any ConnectorProtocol)) {
        self.connector = connector
        
        connector.namePublisher.sink { [weak self] name in
            _ = self?.set(name: name)
        }.store(in: &cancellables)
    }
    
    func singIn(name: String) {
        let authState = set(name: name)
        sync(authState: authState)
    }
    
    func logout() {
        let authState = set(name: nil)
        sync(authState: authState)
    }
}

private extension AuthServiceImpl {
    func set(name: String?) -> AuthState {
        let authState: AuthState
        if let name {
            authState = AuthState.authorized(name: name)
        } else {
            authState = AuthState.unauthorized
        }
        authStatePublished.send(authState)
        return authState
    }
    
    func sync(authState: AuthState) {
        connector.sendData(authState: authState)
    }
}
