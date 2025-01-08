import SwiftUI

@MainActor
protocol MainViewModel {
    var alertViewController: AlertViewController<SimpleAlertViewModel> { get }
    var name: String { get }
    
    func logout()
}

struct MainView<ViewModel: MainViewModel>: View {
    let vm: ViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Text("Main")
                
                Spacer()
                
                Text("Hello, \(vm.name)")
                
                Spacer()
                
                Button("Logout") {
                    vm.logout()
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal, 16)
        .alertView(alertViewController: vm.alertViewController)
    }
}
