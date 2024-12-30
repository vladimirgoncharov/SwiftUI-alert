import Foundation

@propertyWrapper
struct IgnoreHashable<Wrapped: Sendable>: Hashable {
    @IgnoreEquatable var wrappedValue: Wrapped

    func hash(into hasher: inout Hasher) {}
}
