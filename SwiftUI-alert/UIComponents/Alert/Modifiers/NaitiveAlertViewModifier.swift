import SwiftUI

struct NaitiveAlertViewModifier: ViewModifier {
    @ObservedObject public var alertManager: AlertManager
    
    func body(content: Content) -> some View {
        let currentItem = alertManager.current()
        switch currentItem {
        case let .simple(item):
            content
                .alert(item.title,
                       isPresented: $alertManager.isPresented,
                       actions: {
                    ForEach(item.buttons,
                            id: \.self) { button in
                        Button(button.text,
                               role: button.style.role()) {
                            button.action()
                            alertManager.dequeue()
                        }
                    }
                },
                       message: {
                    if let message = item.message {
                        Text(message)
                    }
                })
            
        case .none:
            content
        }
    }
}

private extension AlertItem.Button.Style {
    func role() -> ButtonRole {
        let role: ButtonRole
        switch self {
        case .default: role = .cancel
        case .red: role = .destructive
        }
        return role
    }
}
