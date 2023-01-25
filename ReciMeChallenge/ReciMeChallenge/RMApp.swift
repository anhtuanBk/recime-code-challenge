//
//  ReciMeChallengeApp.swift
//  ReciMeChallenge
//
//  Created by henry on 23/01/2023.
//

import SwiftUI

@main
struct ReciMeChallengeApp: App {
    @StateObject var recipeService = RMRecipeService()
    
    init() {
        // cache config for AsyncImage
        URLCache.shared.diskCapacity = 10*1000*1000*1000
        URLCache.shared.memoryCapacity = 512*1000*1000
    }
    
    var body: some Scene {
        WindowGroup {
            RMRecipeList()
                .environmentObject(recipeService)
        }
    }
}
