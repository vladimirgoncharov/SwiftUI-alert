import Foundation
import SwiftUI

protocol AlertViewModel: Identifiable, Sendable {
    associatedtype AlertViewModifier: ViewModifier
    
    static func makeViewModifier(alertManager: AlertViewController<Self>) -> AlertViewModifier
}
