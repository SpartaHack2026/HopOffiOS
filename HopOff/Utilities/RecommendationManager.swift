//
//  RecommendationManager.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import Foundation

struct Recommendation {
    let app: String
    let hobby: Task
}

enum RecommendationManager {

    static func getRecommendation() -> Recommendation? {
        let defaults = UserDefaults.standard

        // Load hobbies
        guard
            let hobbyData = defaults.data(forKey: "hobbies_list_v2"),
            let hobbies = try? JSONDecoder().decode([Task].self, from: hobbyData),
            !hobbies.isEmpty
        else {
            return nil
        }

        // Load selected apps
        let apps = defaults.stringArray(forKey: "blocked_apps") ?? []
        guard !apps.isEmpty else {
            return nil
        }

        let randomHobby = hobbies.randomElement()!
        let randomApp = apps.randomElement()!

        return Recommendation(app: randomApp, hobby: randomHobby)
    }
}


