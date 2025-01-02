import Foundation
import SwiftUI

struct SimpleAlertViewModel: AlertViewModel {
    
    typealias AlertViewModifier = SimpleAlertViewModifier
    
    struct Button: Identifiable, Sendable {
        let id: UUID = UUID()
        let role: ButtonRole
        let text: String
        let action: @MainActor @Sendable () -> Void
    }

    let id: UUID
    let title: String
    let message: String?
    let buttons: [Button]
    
    init(
        id: UUID = UUID(),
        title: String,
        message: String?,
        buttons: [Button]
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.buttons = buttons
    }
    
    static func makeViewModifier(alertManager: AlertViewController<Self>) -> AlertViewModifier {
        AlertViewModifier(alertManager: alertManager)
    }
}
