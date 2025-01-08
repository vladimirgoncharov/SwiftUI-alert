import Foundation
import SwiftUI

protocol AlertViewModel: Identifiable, Sendable {
    associatedtype AlertViewModifier: ViewModifier
    
    static func makeViewModifier(
        alertViewController: AlertViewController<Self>,
        isPresented: Binding<Bool>
    ) -> AlertViewModifier
}
