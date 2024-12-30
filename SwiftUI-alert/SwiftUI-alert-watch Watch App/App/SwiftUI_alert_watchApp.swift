import SwiftUI
import WatchKit

@main
struct SwiftUI_alert_watch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(vm: ContentViewModelImpl(authService: appDelegate.authService))
        }
    }
}

class AppDelegate: NSObject, WKApplicationDelegate {
    let authService: (any AuthServiceProtocol)
    let phoneConnector: PhoneConnector
    
    override init() {
        self.phoneConnector = PhoneConnector()
        self.authService = AuthServiceImpl(connector: self.phoneConnector)
        super.init()
    }
}
