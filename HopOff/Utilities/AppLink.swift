//
//  AppLink.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import Foundation

struct AppLink {
    let displayName: String
    let scheme: String
    let appURL: URL
    let webURL: URL
}

enum AppLinkStore {
    static let links: [AppLink] = [
        AppLink(
            displayName: "TikTok",
            scheme: "tiktok",
            appURL: URL(string: "tiktok://")!,
            webURL: URL(string: "https://www.tiktok.com")!
        ),
        AppLink(
            displayName: "Instagram",
            scheme: "instagram",
            appURL: URL(string: "instagram://app")!,
            webURL: URL(string: "https://www.instagram.com")!
        ),
        AppLink(
            displayName: "Snapchat",
            scheme: "snapchat",
            appURL: URL(string: "snapchat://")!,
            webURL: URL(string: "https://www.snapchat.com")!
        ),
        AppLink(
            displayName: "Facebook",
            scheme: "fb",
            appURL: URL(string: "fb://")!,
            webURL: URL(string: "https://www.facebook.com")!
        ),
        AppLink(
            displayName: "YouTube",
            scheme: "youtube",
            appURL: URL(string: "youtube://")!,
            webURL: URL(string: "https://www.youtube.com")!
        ),
        AppLink(
            displayName: "X",
            scheme: "twitter",
            appURL: URL(string: "twitter://")!,
            webURL: URL(string: "https://x.com")!
        ),
    ]

    static func link(for recommendationAppName: String) -> AppLink? {
        let key = recommendationAppName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return links.first { $0.displayName.lowercased() == key }
    }
}
