//
//  UserDefaultsManager.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import Foundation
import Combine

enum UserDefaultKeys : String {
    case authToken = "apiAuthenticationToken"
    
    var key : String {
        return self.rawValue
    }
}

final class UserDefaultManager : ObservableObject {
    
    
    public static let shared = UserDefaultManager()
    
    private let standard = UserDefaults.standard
    
    private init() {}
    
    private func set(value: Any, forKey key: UserDefaultKeys) {
        standard.setValue(value, forKey: key.key)
        standard.synchronize()
    }
    
    private func remove(forkey key: UserDefaultKeys) {
        standard.removeObject(forKey: key.key)
    }
    
    
    private func resetDefaults() {
        let dictionary = standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            standard.removeObject(forKey: key)
        }
        standard.synchronize()
    }
    
    
    var authToken : String? {
        set {
            guard let newVal = newValue else { return }
            set(value: newVal, forKey: .authToken)
        } get {
            guard let token = UserDefaults.standard.string(forKey: .authToken) else {
                return nil
            }
            return token
        }
    }
}

extension UserDefaults {
    func string(forKey : UserDefaultKeys) -> String? {
        return self.string(forKey: forKey.rawValue)
    }
}
