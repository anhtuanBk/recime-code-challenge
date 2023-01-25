//
//  RMRecipe.swift
//  ReciMeChallenge
//
//  Created by henry on 24/01/2023.
//

import Foundation

struct RMRecipe: Codable, Identifiable {
    let id: String
    let type, title: String?
    let description: String?
    let recipeURL, originalPost: String?
    let imageURL: String?
    let creator: RMCreator?
    let cookTime: Int?
    let prepTime, servingSize: Int?
    let difficulty, method: String?
    let timestamp: Int?
    let liked, saved: Bool?
    let numLikes, numSaves, numComments, numRecreates: Int?
    let rating: Int?
    let visibility: String?
    let tags: [String]
    let cuisine: String?
    
    var methods: [String] {
        guard let method else {
            return []
        }
        return method.split(separator: "\n")
            .map { sub in
                String(sub)
            }
    }

    enum CodingKeys: String, CodingKey {
        case id, type, title, description
        case recipeURL = "recipeUrl"
        case originalPost
        case imageURL = "imageUrl"
        case creator, cookTime, prepTime, servingSize, difficulty, method, timestamp, liked, saved, numLikes, numSaves, numComments, numRecreates, rating, visibility, tags, cuisine
    }
}

struct RMCreator: Codable {
    let uid, username: String?
    let profileImageURL: String?
    let firstname, lastname: String?
    let isFollowing: Bool?

    enum CodingKeys: String, CodingKey {
        case uid, username
        case profileImageURL = "profileImageUrl"
        case firstname, lastname, isFollowing
    }
}
