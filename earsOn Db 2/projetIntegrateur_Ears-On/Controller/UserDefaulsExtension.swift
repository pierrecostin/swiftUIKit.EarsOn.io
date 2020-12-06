//
//  UserDefaulsExtension.swift
//  projetIntegrateur_Ears-On
//
//  Created by PIERRE COSTIN on 2020-11-21.
//

import Foundation

extension UserDefaults {
    
    enum Key : String {
        case
            speakLanguage,
            hearLanguage
    }
    
    static func remove(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func set(_ value: Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func setBool(_ bool: Bool?, forKey key: Key) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func bool(forKey key: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func string(forKey key: Key) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func integer(forKey key: Key) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func double(forKey key: Key) -> Double {
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    
    static func float(forKey key: Key) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }
    
}

