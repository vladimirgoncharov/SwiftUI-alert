import SwiftUI

struct SheetAlertViewModifier: ViewModifier {
    let alertViewController: AlertViewController<SheetAlertViewModel>
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented,
                   content: {
                if let currentItem = alertViewController.current {
                    Text(currentItem.title)
                    ForEach(currentItem.buttons,
                            id: \.id) { button in
                        Button(button.text) { [weak alertViewController] in
                            button.action()
                            alertViewController?.close(id: currentItem.id)
                        }
                    }
                }
            })
    }
}
