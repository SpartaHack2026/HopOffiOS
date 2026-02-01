//
//  AppDefaults.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import Foundation

enum AppDefaults {
    // Central place for keys
    private enum Keys {
        static let hasOnboarded = "hasOnboarded"
        static let selectedOptionIndex = "selectedOptionIndex"
        static let hasSelectedOptionIndex = "hasSelectedOptionIndex"
    }
    
    // Read
    static var hasOnboarded: Bool {
        UserDefaults.standard.bool(forKey: Keys.hasOnboarded)
    }
    
    // Write
    static func setHasOnboarded(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.hasOnboarded)
    }
    
    // Register default values ONCE at app launch
    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            Keys.hasOnboarded: false
        ])
    }
    
    static var selectedOptionIndex: Int? {
        get {
            let hasValue = UserDefaults.standard.bool(forKey: Keys.hasSelectedOptionIndex)
            guard hasValue else { return nil }
            return UserDefaults.standard.integer(forKey: Keys.selectedOptionIndex)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(true, forKey: Keys.hasSelectedOptionIndex)
                UserDefaults.standard.set(value, forKey: Keys.selectedOptionIndex)
            } else {
                UserDefaults.standard.set(false, forKey: Keys.hasSelectedOptionIndex)
                UserDefaults.standard.removeObject(forKey: Keys.selectedOptionIndex)
            }
        }
    }
    
    static func resetOnboardingOnly() {
        setHasOnboarded(false)
    }

    static func resetAllUserDataForTesting() {
        // Onboarding flag
        setHasOnboarded(false)

        // If you want to clear app selection you stored elsewhere
        selectedOptionIndex = nil

        // Clear your custom keys you used in other VCs
        UserDefaults.standard.removeObject(forKey: "blocked_apps")     // from ChooseApps
        UserDefaults.standard.removeObject(forKey: "hobbies_list_v2")  // from Hobbies
    }

}

