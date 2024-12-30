import Foundation

@MainActor
final class MainViewModelImpl: MainViewModel {
    @Published var alertManager = AlertManager(style: .native)

    let name: String

    private let authService: (any AuthServiceProtocol)
    
    init(authService: (any AuthServiceProtocol)) {
        self.authService = authService
        self.name = AuthStatePresenter(authState: authService.authState).representation
    }
    
    func logout() {
        alertManager.enqueue(logoutAlert())
        alertManager.enqueue(confirmLogoutAlert())
    }
}

// MARK: - Alert

private extension MainViewModelImpl {
    func logoutAlert() -> AlertItem {
        .simple(item: .init(title: "Log out",
                            message: "Are you sure?",
                            buttons: [
                                .init(style: .red,
                                      text: "Yes",
                                      action: {
                                          print("Select Yes")
                                      }),
                                .init(style: .default,
                                      text: "Cancel",
                                      action: { [weak self] in
                                          print("Select Cancel")
                                          self?.alertManager.clearAll()
                                      })
                            ]))
    }
    
    func confirmLogoutAlert() -> AlertItem {
        .simple(item: .init(title: "Confirm log out",
                            message: "You will not be able to undo this action",
                            buttons: [
                                .init(style: .red,
                                      text: "Yes!",
                                      action: { [weak self] in
                                          print("Confirmed Yes")
                                          self?.authService.logout()
                                      }),
                                .init(style: .default,
                                      text: "Cancel",
                                      action: { [weak self] in
                                          print("Select Cancel")
                                          self?.alertManager.clearAll()
                                      })
                            ]))
    }
}
