import SwiftUI

@MainActor
protocol SignInViewModel: ObservableObject {
    var inputName: String { get set }
    
    func signIn()
}

struct SignInView<ViewModel: SignInViewModel>: View {
    @StateObject var vm: ViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Sing In")

                Spacer()
                
                TextField("Input your name",
                          text: $vm.inputName)
                
                Spacer()
                
                Button("Sign In") {
                    vm.signIn()
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal, 16)
    }
}
