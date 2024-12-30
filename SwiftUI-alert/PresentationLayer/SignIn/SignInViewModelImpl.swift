import Foundation

@MainActor
final class SignInViewModelImpl: SignInViewModel {
    @Published var inputName: String = ""

    private let authService: (any AuthServiceProtocol)
    
    init(authService: (any AuthServiceProtocol)) {
        self.authService = authService
    }
    
    func signIn() {
        authService.singIn(name: inputName)
    }
}
