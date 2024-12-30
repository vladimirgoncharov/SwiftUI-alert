import SwiftUI

@main
struct SwiftUI_alertApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(vm: ContentViewModelImpl(authService: appDelegate.authService))
        }
    }
}

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    let authService: (any AuthServiceProtocol)
    let watchConnecter: WatchConnector
    
    override init() {
        self.watchConnecter = WatchConnector()
        self.authService = AuthServiceImpl(connector: self.watchConnecter)
        
        super.init()
    }
}
