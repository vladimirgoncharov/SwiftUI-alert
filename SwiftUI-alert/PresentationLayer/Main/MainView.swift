import SwiftUI

@MainActor
protocol MainViewModel: ObservableObject {
    var name: String { get }
    
#if os(iOS)
    func logout()
#endif
}

struct MainView<ViewModel: MainViewModel>: View {
    @StateObject var vm: ViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                Text("Hello, \(vm.name)")
                
                Spacer()
                
#if os(iOS)
                Button("Logout") {
                    vm.logout()
                }
                .padding(.bottom, 20)
#endif
            }
        }
        .padding(.horizontal, 16)
    }
}
