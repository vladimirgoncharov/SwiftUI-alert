import Foundation

@MainActor
final class MainViewModelImpl: MainViewModel {
    @Published var alertViewController = AlertViewController<SimpleAlertViewModel>()
    
    let name: String
    
    private var logoutTimer: Timer?
    
    private let authService: (any AuthServiceProtocol)
    
    init(authService: (any AuthServiceProtocol)) {
        self.authService = authService
        self.name = AuthStatePresenter(authState: authService.authState).representation
    }
    
    func logout() {
        runLogoutTimer()
        alertViewController.show(logoutAlert())
        alertViewController.show(confirmLogoutAlert())
    }
}

// MARK: - Timer

private extension MainViewModelImpl {
    func runLogoutTimer() {
        invalidateLogoutTimer()
        
        logoutTimer = Timer.scheduledTimer(withTimeInterval: 10.0,
                                           repeats: false) { [weak self] timer in
            Task { @MainActor [weak self] in
                self?.invalidateLogoutTimer()
                self?.authService.logout()
            }
        }
    }
    
    func invalidateLogoutTimer() {
        logoutTimer?.invalidate()
        logoutTimer = nil
    }
}

// MARK: - Alert

private extension MainViewModelImpl {
    func logoutAlert() -> SimpleAlertViewModel {
        SimpleAlertViewModel(
            title: "Cancel logout",
            message: "You have 10 seconds to cancel",
            buttons: [
                SimpleAlertViewModel.Button(
                    role: .cancel,
                    text: "No, Please!",
                    action: { [weak self] in
                        print("Cancelled")
                        self?.alertViewController.closeAll()
                        self?.invalidateLogoutTimer()
                    }
                ),
                SimpleAlertViewModel.Button(
                    role: .destructive,
                    text: "YEEEEEES",
                    action: {
                        print("Select log out")
                    }
                )
            ]
        )
    }
    
    func confirmLogoutAlert() -> SimpleAlertViewModel {
        SimpleAlertViewModel(
            title: "Confirm to cancel log out",
            message: "Tik Tak Tik Tak Tik Tak Tik Tak...",
            buttons: [
                SimpleAlertViewModel.Button(
                    role: .cancel,
                    text: "I've changed my mind",
                    action: { [weak self] in
                        print("Cancelled")
                        self?.alertViewController.closeAll()
                        self?.invalidateLogoutTimer()
                    }
                ),
                SimpleAlertViewModel.Button(
                    role: .destructive,
                    text: "Yes!!!!!",
                    action: { [weak self] in
                        self?.authService.logout()
                        print("Confirmed log out")
                    }
                )
            ]
        )
    }
}
