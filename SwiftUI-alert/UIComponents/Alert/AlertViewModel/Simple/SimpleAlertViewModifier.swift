import SwiftUI

struct SimpleAlertViewModifier: ViewModifier {
    let alertViewController: AlertViewController<SimpleAlertViewModel>
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        if let currentItem = alertViewController.current {
            content
                .alert(
                    currentItem.title,
                    isPresented: $isPresented,
                    actions: { [currentItem] in
                        ForEach(currentItem.buttons,
                                id: \.id) { button in
                            Button(button.text,
                                   role: button.role) { [weak alertViewController] in
                                button.action()
                                alertViewController?.close(id: currentItem.id)
                            }
                        }
                    },
                    message: {
                        if let message = currentItem.message {
                            Text(message)
                        }
                    }
                )
        } else {
            content
        }
    }
}
