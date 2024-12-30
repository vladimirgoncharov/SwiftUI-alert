import SwiftUI
import Combine

@MainActor
final class AlertManager: ObservableObject {
    enum Style {
        case native
    }

    @Published var isPresented = false

    private var queues: [AlertItem] = []
    
    let style: Style
    
    private var cancellable: AnyCancellable?

    init(style: Style) {
        self.style = style

        cancellable = $isPresented
            .filter({ [weak self] isPresented in
                guard let self = self else {
                    return false
                }
                return !isPresented && !self.queues.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.isPresented = true
            })
    }

    func enqueue(_ alert: AlertItem) {
        queues.append(alert)
        isPresented = true
    }

    func dequeue() {
        if !queues.isEmpty {
            queues.removeFirst()
        }
    }

    func current() -> AlertItem? {
        queues.first
    }
    
    func clearAll() {
        queues.removeAll()
    }
}
