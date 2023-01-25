//
//  RecipeAPIRequests.swift
//  
//
//
//

import Foundation

let baseURLString: String = "https://dev.api.recime.app"

/// Get a user
struct RMRecipeListRequest: RMAPIBaseRequest {
    typealias Response = [RMRecipe]
    
    let baseURL: URL = URL(string: baseURLString)!
    var path: String {
        "web-api/profile/\(userId)/posts"
    }
    let method: HTTPMethod = .get
    let body: String = ""
    let queryItems: [URLQueryItem] = []
    let userId: String
    
    init(_ userId: String) {
        self.userId = userId
    }
}

struct RMRecipeDetailRequest: RMAPIBaseRequest {
    typealias Response = RMRecipe
    
    let baseURL: URL = URL(string: baseURLString)!
    var path: String {
        "web-api/recipe/\(recipeId)"
    }
    let method: HTTPMethod = .get
    let body: String = ""
    let queryItems: [URLQueryItem] = []
    let recipeId: String
    
    init(_ recipeId: String) {
        self.recipeId = recipeId
    }
}

struct RMRecipeIngredientsRequest: RMAPIBaseRequest {
    typealias Response = [RMIngredent]
    
    let baseURL: URL = URL(string: baseURLString)!
    var path: String {
        "web-api/recipe/\(recipeId)/ingredients"
    }
    let method: HTTPMethod = .get
    let body: String = ""
    let queryItems: [URLQueryItem] = []
    let recipeId: String
    
    init(_ recipeId: String) {
        self.recipeId = recipeId
    }
}
