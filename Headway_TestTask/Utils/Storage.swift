//
//  Storage.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 27.10.2020.
//

import Foundation

protocol ObjectSavable {
    func saveObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

protocol TokenSavable {
    func saveToken(_ token: String)
    func getToken() -> String?
}

protocol StorageSavable: ObjectSavable, TokenSavable {}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

class Storage: StorageSavable {
    func saveObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = UserDefaults.standard.data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }
}
