import Foundation
import SwiftUI

struct SheetAlertViewModel: AlertViewModel {
    
    typealias AlertViewModifier = SheetAlertViewModifier
    
    struct Button: Identifiable, Sendable {
        let id: UUID = UUID()
        let text: String
        let action: @MainActor @Sendable () -> Void
    }

    let id: UUID
    let title: String
    let buttons: [Button]
    
    init(
        id: UUID = UUID(),
        title: String,
        buttons: [Button]
    ) {
        self.id = id
        self.title = title
        self.buttons = buttons
    }
    
    static func makeViewModifier(
        alertViewController: AlertViewController<Self>,
        isPresented: Binding<Bool>
    ) -> AlertViewModifier {
        AlertViewModifier(alertViewController: alertViewController,
                          isPresented: isPresented)
    }
}
