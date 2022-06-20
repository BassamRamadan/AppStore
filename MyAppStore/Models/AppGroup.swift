//
//  AppGroup.swift
//  MyAppStore
//
//  Created by Bassam on 6/11/22.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}
struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}
struct FeedResult: Decodable {
    let name, artistName, artworkUrl100: String
}
struct SocialApp: Decodable {
    let name,tagline,imageUrl: String
}
