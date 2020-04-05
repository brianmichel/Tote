//
//  Keychain.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation
import KeychainAccess

final class Keychain {
    private enum Constants {
        static let keychainAccessGroup = "me.foureyes.Tote"
    }

    let service: String?

    private let chain: KeychainAccess.Keychain

    var allKeys: [String] {
        return chain.allKeys()
    }

    init(service: String? = nil) {
        self.service = service
        chain = KeychainAccess.Keychain()
    }

    subscript<T: Codable>(key: String) -> T? {
        get {
            return retreive(key)
        }
        set {
            store(codable: newValue, for: key)
        }
    }

    func remove(valueFor key: String) {
        do {
            try chain.remove(key)
        } catch {
            Log.error("Unable to remove value for key: '\(key)' - \(String(describing: error))")
        }
    }

    func removeAllItems() {
        do {
            try chain.removeAll()
        } catch {
            Log.error("Unable to remove all items from keychain")
        }
    }

    // MARK: Codable Storage

    private func store<T: Encodable>(codable: T?, for key: String) {
        do {
            guard let settableValue = codable else {
                try chain.remove(key)
                return
            }

            if let data = try? JSONEncoder().encode(settableValue) {
                try chain.set(data, key: key)
            }
        } catch {
            Log.error("Unable to set value for '\(key)' of type \(T.self) - '\(String(describing: error))'")
        }
    }

    private func retreive<T: Decodable>(_ key: String) -> T? {
        do {
            guard let data = try chain.getData(key) else {
                return nil
            }

            let decoded = try JSONDecoder().decode(T.self, from: data)

            return decoded
        } catch {
            Log.error("Unable to retreive value for '\(key)' of type \(T.self) - '\(String(describing: error))'")
            return nil
        }
    }
}
