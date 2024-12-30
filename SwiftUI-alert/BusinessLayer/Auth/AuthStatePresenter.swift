import Foundation

struct AuthStatePresenter: Sendable {
    let authState: AuthState
    
    var name: String? {
        switch authState {
        case let .authorized(name): return name
        case .unauthorized: return nil
        }
    }

    var representation: String {
        let name = self.name
        if let name, !name.isEmpty {
            return name
        } else {
            return "Guest"
        }
    }
}
