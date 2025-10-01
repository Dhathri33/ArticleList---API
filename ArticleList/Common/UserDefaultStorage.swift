//
//  UserDefaultStorage.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 10/1/25.
//

import Foundation

class UserDefaultStorage {
    static let shared = UserDefaultStorage()
    let defaultStorage = UserDefaults.standard
    private init() {}
    
    func set(_ value: String?, forKey key: String) {
        defaultStorage.set(value, forKey: key)
        defaultStorage.synchronize()
    }
    
    func getString(forKey key: String) -> String? {
        return defaultStorage.string(forKey: key)
    }
}
