import Combine
import Foundation
import SwiftUI

@propertyWrapper
public struct StoredState<Value: Codable & Sendable>: DynamicProperty, Sendable {
    public let defaultValue: Value
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    @AppStorage private var data: Data

    public init(
        key: String,
        defaultValue: Value,
        store: UserDefaults = .standard
    ) {
        self.defaultValue = defaultValue
        let defaultData = (try? self.encoder.encode(defaultValue)) ?? Data()
        self._data = AppStorage(wrappedValue: defaultData, key, store: store )
    }

    public init(
        wrappedValue defaultValue: Value,
        _ key: String,
        store: UserDefaults = .standard
    ) {
        self.init(
            key: key,
            defaultValue: defaultValue,
            store: store
        )
    }

    public var wrappedValue: Value {
        get {
            guard let decoded = try? self.decoder.decode(Value.self, from: data)
            else { print("failed to decode \(String(data: self.data, encoding: .utf8) ?? "Not A Data")"); return defaultValue; }
            return decoded
        }

        nonmutating set {
            guard let encoded = try? self.encoder.encode(newValue)
            else { print("failed to encode"); return; }
            self.data = encoded
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    public func removeValue() { data.removeAll() }
}
