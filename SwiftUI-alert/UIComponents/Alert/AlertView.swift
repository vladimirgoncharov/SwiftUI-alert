import SwiftUI

// MARK: - Fabric

extension View {
    @ViewBuilder
    func alertView(alertManager: AlertManager) -> some View {
        switch alertManager.style {
        case .native: self.modifier(NaitiveAlertViewModifier(alertManager: alertManager))
        }
    }
}
