//
//  RecommendationManager.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import Foundation

struct Recommendation: Codable, Equatable {
    let app: String
    let hobby: Task
}
//
//enum RecommendationManager {
//
//    static func getRecommendation() -> Recommendation? {
//        let defaults = UserDefaults.standard
//
//        // Load hobbies
//        guard
//            let hobbyData = defaults.data(forKey: "hobbies_list_v2"),
//            let hobbies = try? JSONDecoder().decode([Task].self, from: hobbyData),
//            !hobbies.isEmpty
//        else {
//            return nil
//        }
//
//        // Load selected apps
//        let apps = defaults.stringArray(forKey: "blocked_apps") ?? []
//        guard !apps.isEmpty else {
//            return nil
//        }
//
//        let randomHobby = hobbies.randomElement()!
//        let randomApp = apps.randomElement()!
//
//        return Recommendation(app: randomApp, hobby: randomHobby)
//    }
//}


enum RecommendationManager {

    // MARK: - Keys (match your existing keys)
    private static let hobbiesKey = "hobbies_list_v2"
    private static let appsKey = "blocked_apps"

    // New key: we store the current recommendation so the UI is stable
    private static let currentRecKey = "current_recommendation_v1"

    // MARK: - Public API

    /// OpeningPage should call this to display the current recommendation.
    /// If we already have a saved recommendation, we return it.
    /// Otherwise, we generate one from the saved lists and persist it.
    static func getRecommendation() -> Recommendation? {
        if let saved = loadSavedRecommendation() {
            return saved
        }

        guard let fresh = makeRandomRecommendation(avoidingApp: nil, avoidingTask: nil) else {
            return nil
        }

        saveRecommendation(fresh)
        return fresh
    }

    /// Call this when user taps HopOff.
    /// It generates the "next" recommendation (tries to avoid repeating)
    /// and saves it, so when you return to OpeningPage it shows the new one.
    static func rollNextRecommendation(avoidingSameApp: Bool = true, avoidingSameTask: Bool = true) {
        let current = loadSavedRecommendation()

        let avoidApp = (avoidingSameApp ? current?.app : nil)
        let avoidTask = (avoidingSameTask ? current?.hobby : nil)

        let maxAttempts = 12

        for _ in 0..<maxAttempts {
            if let next = makeRandomRecommendation(avoidingApp: avoidApp, avoidingTask: avoidTask) {
                saveRecommendation(next)
                return
            }
        }

        // Fallback: if you only have 1 app or 1 task, avoiding may be impossible.
        if let fallback = makeRandomRecommendation(avoidingApp: nil, avoidingTask: nil) {
            saveRecommendation(fallback)
        } else {
            clearRecommendation()
        }
    }

    /// Optional: if user changes their list, call this so the next time
    /// OpeningPage loads, it builds a new recommendation.
    static func clearRecommendation() {
        UserDefaults.standard.removeObject(forKey: currentRecKey)
    }

    // MARK: - Internals

    private static func loadSavedRecommendation() -> Recommendation? {
        guard
            let data = UserDefaults.standard.data(forKey: currentRecKey),
            let rec = try? JSONDecoder().decode(Recommendation.self, from: data)
        else { return nil }
        return rec
    }

    private static func saveRecommendation(_ rec: Recommendation) {
        guard let data = try? JSONEncoder().encode(rec) else { return }
        UserDefaults.standard.set(data, forKey: currentRecKey)
    }

    private static func loadTasks() -> [Task] {
        guard
            let hobbyData = UserDefaults.standard.data(forKey: hobbiesKey),
            let hobbies = try? JSONDecoder().decode([Task].self, from: hobbyData)
        else { return [] }
        return hobbies
    }

    private static func loadApps() -> [String] {
        UserDefaults.standard.stringArray(forKey: appsKey) ?? []
    }

    private static func makeRandomRecommendation(
        avoidingApp: String?,
        avoidingTask: Task?
    ) -> Recommendation? {
        let tasks = loadTasks()
        let apps = loadApps()

        guard !tasks.isEmpty, !apps.isEmpty else { return nil }

        // Avoid the same app if possible
        let appCandidates: [String] = {
            guard let avoidingApp else { return apps }
            let filtered = apps.filter { $0 != avoidingApp }
            return filtered.isEmpty ? apps : filtered
        }()

        // Avoid the same task if possible
        let taskCandidates: [Task] = {
            guard let avoidingTask else { return tasks }
            let filtered = tasks.filter { $0 != avoidingTask }
            return filtered.isEmpty ? tasks : filtered
        }()

        guard
            let app = appCandidates.randomElement(),
            let task = taskCandidates.randomElement()
        else { return nil }

        return Recommendation(app: app, hobby: task)
    }
}
