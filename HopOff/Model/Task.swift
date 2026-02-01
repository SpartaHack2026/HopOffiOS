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

enum ActivityCategory: String, CaseIterable, Codable {
    case hobby = "Hobby"
    case school = "School"
    case chores = "Chores"
    case exercise = "Exercise"
}
