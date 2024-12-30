import Foundation

@MainActor
final class MainViewModelImpl: MainViewModel {
    let name: String

    private let authService: (any AuthServiceProtocol)
    
    init(authService: (any AuthServiceProtocol)) {
        self.authService = authService
        self.name = AuthStatePresenter(authState: authService.authState).representation
    }
    
    func logout() {
        authService.logout()
    }
}
