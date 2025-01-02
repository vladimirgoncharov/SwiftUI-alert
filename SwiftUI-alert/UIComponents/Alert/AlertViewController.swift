import SwiftUI
import Combine

extension View {
    @ViewBuilder
    func alertView<ViewModel: AlertViewModel>(alertManager: AlertViewController<ViewModel>) -> some View {
        self.modifier(ViewModel.makeViewModifier(alertManager: alertManager))
    }
}

// TODO: - Use iOS 17+ @Observable

@MainActor
final class AlertViewController<ViewModel: AlertViewModel>: ObservableObject {
    
    @Published var isPresented = false
    
    private var alerts: [ViewModel] = []
    
    var current: ViewModel? {
        alerts.first
    }
    
    var isShowed: Bool {
        !alerts.isEmpty
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        $isPresented
            .filter { [weak self] isPresented in
                guard let self else {
                    return false
                }
                return !isPresented && !self.alerts.isEmpty
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isPresented = true
            }
            .store(in: &cancellable)
    }
    
    func show(_ alert: ViewModel) {
        let indexAlert = index(id: alert.id)
        if let indexAlert {
            alerts[indexAlert] = alert
        } else {
            alerts.append(alert)
        }
        isPresented = true
    }
    
    func showWithReplace(_ alert: ViewModel) {
        // TODO: - На данный момент получается show делает тоже самое
        show(alert)
    }
    
    func close(id: ViewModel.ID) {
        let indexAlert = index(id: id)
        if let indexAlert {
            alerts.remove(at: indexAlert)
        }
    }
    
    func closeAll() {
        alerts.removeAll()
    }
}

fileprivate extension AlertViewController {
    func index(id: ViewModel.ID) -> Int? {
        return alerts.firstIndex {
            $0.id == id
        }
    }
}
