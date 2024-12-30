import Foundation

enum AuthState: Sendable, Codable {
    case unauthorized
    case authorized(name: String)
}
