import SwiftUI

enum AlertItem: Hashable, Sendable {
    struct Button: Hashable, Sendable {
        enum Style: Hashable, Sendable {
            case `default`
            case red
        }
        var style: Style
        var text: String
        @IgnoreHashable
        var action: @MainActor @Sendable () -> Void
    }

    struct SimpleItem: Hashable, Sendable {
        let title: String
        let message: String?
        let buttons: [Button]
        
        init(title: String,
             message: String?,
             buttons: [Button]) {
            assert(buttons.count > 0, "buttons can't be empty")
            self.title = title
            self.message = message
            self.buttons = buttons
        }
    }

    case simple(item: SimpleItem)
}
