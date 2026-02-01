//
//  Task.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import Foundation

struct Task: Codable, Equatable {
    var title: String
    var category: ActivityCategory
}

struct Hobby: Codable, Equatable {
    let id: UUID
    let title: String

    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}

enum ActivityCategory: String, CaseIterable, Codable {
    case hobby = "Hobby"
    case school = "School"
    case chores = "Chores"
    case exercise = "Exercise"
}
