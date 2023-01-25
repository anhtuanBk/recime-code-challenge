//
//  RMRecipeService.swift
//  ReciMeChallenge
//
//  Created by henry on 24/01/2023.
//

import Foundation
import Combine

// Model-View pattern insprise from
// https://developer.apple.com/documentation/swiftui/fruta_building_a_feature-rich_app_with_swiftui
// and https://developer.apple.com/forums/thread/699003

final class RMRecipeService: ObservableObject {
    @Published var recipes: [RMRecipe] = []
    @Published var seletedRecipeId: String? = nil
    @Published var selectedRecipe: RMRecipe? = nil
    @Published var selectedIngredients: [RMIngredent] = []
    @Published var isLoading: Bool = false
    @Published var loadError: Error? = nil
    
    private let userId: String
    private let restClient: RMAPIClient
    private var bag = Set<AnyCancellable>()
    
    // will be replace with actual User Id (ex: from User Management service) in real app
    init(_ userId: String = "7NWpTwiUWQMm89GS3zJW7Is3Pej1", restClient: RMAPIClient = DefaultRMAPIClient()) {
        self.userId = userId
        self.restClient = restClient
        
        getRecipes()
        
        _seletedRecipeId
            .projectedValue
            .sink { [weak self] id in
                self?.getRecipe()
            }
            .store(in: &bag)
    }
    
    private func getRecipes() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.isLoading = true
            do {
                let fetchedRecipes = try await self.restClient.send(request: RMRecipeListRequest(self.userId))
                self.recipes = fetchedRecipes
            } catch {
                self.loadError = error
            }
            self.isLoading = false
        }
    }
    
    private func getRecipe() {
        Task { @MainActor [weak self] in
            guard let self, let seletedRecipeId else {
                return
            }
            
            self.isLoading = true
            do {
                self.selectedRecipe = try await restClient.send(request: RMRecipeDetailRequest(seletedRecipeId))
                self.selectedIngredients = try await restClient.send(request: RMRecipeIngredientsRequest(seletedRecipeId))
            } catch {
                self.loadError = error
            }
            self.isLoading = false
        }
    }
}
