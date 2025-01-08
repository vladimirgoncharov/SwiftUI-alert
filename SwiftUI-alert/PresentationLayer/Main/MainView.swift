import SwiftUI

@MainActor
protocol MainViewModel {
    var simpleAlertViewController: AlertViewController<SimpleAlertViewModel> { get }
    var sheetAlertViewController: AlertViewController<SheetAlertViewModel> { get }

    var name: String { get }
    
    func onAppear()
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
        .alertView(alertViewController: vm.simpleAlertViewController)
        .alertView(alertViewController: vm.sheetAlertViewController)
        .onAppear {
            vm.onAppear()
        }
    }
}
