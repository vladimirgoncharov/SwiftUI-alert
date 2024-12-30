import Foundation

@propertyWrapper
struct IgnoreEquatable<Wrapped: Sendable>: Equatable {
    var wrappedValue: Wrapped
    
    static func == (lhs: IgnoreEquatable<Wrapped>,
                    rhs: IgnoreEquatable<Wrapped>) -> Bool {
        true
    }
}
