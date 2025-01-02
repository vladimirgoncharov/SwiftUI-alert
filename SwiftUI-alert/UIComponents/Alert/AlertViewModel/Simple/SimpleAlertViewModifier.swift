import Foundation
import SwiftUI

// TODO: - Добавить в отдельный файл SystemNotification.

struct SimpleAlertViewModifier: ViewModifier {
    @ObservedObject var alertManager: AlertViewController<SimpleAlertViewModel>
    
    func body(content: Content) -> some View {
        if let currentItem = alertManager.current {
            content
                .alert(
                    currentItem.title,
                    isPresented: $alertManager.isPresented,
                    actions: {
                        ForEach(currentItem.buttons,
                                id: \.id) { button in
                            Button(button.text,
                                   role: button.role) { [weak alertManager] in
                                button.action()
                                alertManager?.close(id: currentItem.id)
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
