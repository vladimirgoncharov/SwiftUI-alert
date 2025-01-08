import Foundation

@MainActor @Observable
final class MainViewModelImpl: MainViewModel {
    let simpleAlertViewController = AlertViewController<SimpleAlertViewModel>()
    let sheetAlertViewController = AlertViewController<SheetAlertViewModel>()
    
    let name: String
    
    @ObservationIgnored
    private var logoutTimer: Timer?
    
    private let authService: (any AuthServiceProtocol)
    
    init(authService: (any AuthServiceProtocol)) {
        self.authService = authService
        self.name = AuthStatePresenter(authState: authService.authState).representation
    }
    
    func onAppear() {
        sheetAlertViewController.show(sheetAlert())
    }
    
    func logout() {
        runLogoutTimer()
        simpleAlertViewController.show(logoutAlert())
        simpleAlertViewController.show(confirmLogoutAlert())
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

// MARK: - Simple Alert

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
                        self?.simpleAlertViewController.closeAll()
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
                        self?.simpleAlertViewController.closeAll()
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

// MARK: - Sheet Alert

private extension MainViewModelImpl {
    func sheetAlert() -> SheetAlertViewModel {
        SheetAlertViewModel(
            title: "Greeting, \(name)",
            buttons: [
                SheetAlertViewModel.Button(
                    text: "Thanks",
                    action: {
                        print("Press thanks")
                    }
                )
            ]
        )
    }
}
