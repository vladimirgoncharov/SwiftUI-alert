import Foundation

@MainActor
final class MainViewModelImpl: MainViewModel {
    @Published var alertManager = AlertManager(style: .native)

    let name: String
    
    private var logoutTimer: Timer?

    private let authService: (any AuthServiceProtocol)
    
    init(authService: (any AuthServiceProtocol)) {
        self.authService = authService
        self.name = AuthStatePresenter(authState: authService.authState).representation
    }
    
    func logout() {
        runLogoutTimer()
        alertManager.enqueue(logoutAlert())
        alertManager.enqueue(confirmLogoutAlert())
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
    func logoutAlert() -> AlertItem {
        .simple(item: .init(title: "Cancel logout",
                            message: "You have 10 seconds to cancel",
                            buttons: [
                                .init(style: .default,
                                      text: "No, Please!",
                                      action: { [weak self] in
                                          print("Cancelled")
                                          self?.alertManager.clearAll()
                                          self?.invalidateLogoutTimer()
                                      }),
                                .init(style: .red,
                                      text: "YEEEEEES",
                                      action: {
                                          print("Select log out")
                                      })
                            ]))
    }

    func confirmLogoutAlert() -> AlertItem {
        .simple(item: .init(title: "Confirm to cancel log out",
                            message: "Tik Tak Tik Tak Tik Tak Tik Tak...",
                            buttons: [
                                .init(style: .default,
                                      text: "I've changed my mind",
                                      action: { [weak self] in
                                          print("Cancelled")
                                          self?.alertManager.clearAll()
                                          self?.invalidateLogoutTimer()
                                      }),
                                .init(style: .red,
                                      text: "Yes!!!!!",
                                      action: { [weak self] in
                                          self?.authService.logout()
                                          print("Confirmed log out")
                                      })
                            ]))
    }
}
