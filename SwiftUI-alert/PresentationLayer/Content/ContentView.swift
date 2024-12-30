import SwiftUI

@MainActor
protocol ContentViewModel: ObservableObject {
    var authService: (any AuthServiceProtocol) { get }
    var authState: AuthState { get }
}

struct ContentView<ViewModel: ContentViewModel>: View {
    @StateObject var vm: ViewModel
    
    var body: some View {
        switch vm.authState {
        case .unauthorized:
            SignInView(vm: SignInViewModelImpl(authService: vm.authService))
        case .authorized:
            MainView(vm: MainViewModelImpl(authService: vm.authService))
        }
    }
}
