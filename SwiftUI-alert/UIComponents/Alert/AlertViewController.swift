import SwiftUI

extension View {
    @ViewBuilder
    func alertView<ViewModel: AlertViewModel>(
        alertViewController: AlertViewController<ViewModel>
    ) -> some View {
        self.modifier(
            ViewModel.makeViewModifier(
                alertViewController: alertViewController,
                isPresented: .init(
                    get: {
                        alertViewController.isShowed
                    },
                    set: { _ in
                        alertViewController.checkIsShowed()
                    }
                )
            )
        )
    }
}

@MainActor @Observable
final class AlertViewController<ViewModel: AlertViewModel> {
    private var alerts: [ViewModel] = []

    var current: ViewModel? {
        alerts.first
    }

    private(set) var isShowed: Bool = false
    
    func show(_ alert: ViewModel) {
        let indexAlert = index(id: alert.id)
        if let indexAlert {
            alerts[indexAlert] = alert
        } else {
            alerts.append(alert)
        }
        checkIsShowed()
    }
    
    func showWithReplace(_ alert: ViewModel) {
        // TODO: - На данный момент получается show делает тоже самое
        show(alert)
    }
    
    func close(id: ViewModel.ID) {
        let indexAlert = index(id: id)
        if let indexAlert {
            alerts.remove(at: indexAlert)
            checkIsShowed()
        }
    }
    
    func closeAll() {
        alerts.removeAll()
        checkIsShowed()
    }
}

private extension AlertViewController {
    func index(id: ViewModel.ID) -> Int? {
        return alerts.firstIndex {
            $0.id == id
        }
    }
    
    func checkIsShowed() {
        isShowed = !alerts.isEmpty
    }
}
