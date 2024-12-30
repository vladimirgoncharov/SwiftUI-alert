import SwiftUI
import Combine

@MainActor
final class ContentViewModelImpl: ContentViewModel {
    @Published var authState: AuthState

    let authService: (any AuthServiceProtocol)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: (any AuthServiceProtocol)) {
        self.authService = authService
        self.authState = authService.authState

        authService.authStatePublisher.sink { [weak self] authState in
            withAnimation {
                self?.authState = authState
            }
        }.store(in: &cancellables)
    }
}
