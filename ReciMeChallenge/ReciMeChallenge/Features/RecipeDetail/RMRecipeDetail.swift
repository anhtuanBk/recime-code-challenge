//
//  RMRecipeDetail.swift
//  ReciMeChallenge
//
//  Created by henry on 25/01/2023.
//

import SwiftUI

struct RMRecipeDetail: View {
    @EnvironmentObject private var recipeService: RMRecipeService
    
    var body: some View {
        Group {
            if !recipeService.isLoading {
                GeometryReader { geo in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            RMRecipeDetailHeader(width: geo.size.width - 48)
                            RMRecipeDetailIngredients()
                            RMRecipeDetailMethod()
                            RMRecipeDetailTags()
                        }
                    }
                    .padding(24)
                }
            } else {
                ProgressView()
            }
        }
    }
}

struct RMRecipeDetailHeader: View {
    @EnvironmentObject private var recipeService: RMRecipeService
    let width: CGFloat
    
    var body: some View {
        let recipe = recipeService.selectedRecipe
        VStack(alignment: .leading) {
            Text(recipe?.title ?? "")
                .font(.title)
            
            HStack {
                CachedAsyncImage(url: URL(string: recipe?.creator?.profileImageURL ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                Text("By \(recipe?.creator?.username ?? "")")
                    .padding(.leading, 16)
            }
            
            HStack(spacing: 16) {
                if let prepTime = recipe?.prepTime {
                    VStack(alignment: .leading) {
                        Text("Prep time")
                        Text("\(prepTime) mins")
                            .font(.title2)
                    }
                }
                
                if let cookTime = recipe?.cookTime {
                    VStack(alignment: .leading) {
                        Text("Cook time")
                        Text("\(cookTime) mins")
                            .font(.title2)
                    }
                }
                
                if let difficulty = recipe?.difficulty {
                    VStack(alignment: .leading) {
                        Text("Difficulty")
                        Text("\(difficulty)")
                            .font(.title2)
                    }
                }
            }
            
            CachedAsyncImage(url: URL(string: recipe?.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(1.2, contentMode: .fill)
            .frame(width: width)
            .frame(maxHeight: .infinity)
            .cornerRadius(16)
            .clipped()
            
            Text("About")
                .font(.title3)
                .padding(.bottom, 8)
            Text(recipe?.description ?? "")
        }
    }
}

struct RMRecipeDetailIngredients: View {
    @EnvironmentObject private var recipeService: RMRecipeService
    
    @State private var servingSize = 1
    @State private var ingredients: [RMIngredent] = []
    
    var body: some View {
        let originalServeSize = recipeService.selectedRecipe?.servingSize ?? 1
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.title)
                .padding(.bottom, 8)
            HStack {
                Button {
                    servingSize += 1
                    var updatedIngredients: [RMIngredent] = []
                    ingredients.forEach { ingredient in
                        var ingredient = ingredient
                        ingredient.increaseServe(Double(originalServeSize))
                        updatedIngredients.append(ingredient)
                    }
                    ingredients = updatedIngredients
                } label: {
                    Text("+")
                }
                
                Text("\(servingSize) serves")
                
                Button {
                    servingSize -= 1
                    var updatedIngredients: [RMIngredent] = []
                    ingredients.forEach { ingredient in
                        var ingredient = ingredient
                        ingredient.decreaseServe(Double(originalServeSize))
                        updatedIngredients.append(ingredient)
                    }
                    ingredients = updatedIngredients
                } label: {
                    Text("-")
                }
            }
            .padding(8)
            
            VStack(alignment: .leading) {
                ForEach(Array(zip(ingredients.indices, ingredients)), id: \.0) { _, ingredient in
                    Group {
                        if let heading = ingredient.heading {
                            Text(heading)
                                .font(.title3)
                                .bold()
                                .padding(.vertical, 16)
                        } else if let rawProduct = ingredient.rawProduct {
                            //placeholder image
                            let quantity = String(format: "%.2f", ingredient.quantity ?? 0)
                            RMIngredientItem(imageName: "ig", quantityText: "\(quantity) \(ingredient.productModifier ?? "")", rawText: "\(rawProduct)", note: ingredient.preparationNotes ?? "")
                        } else {
                            RMIngredientItem(imageName: "ig", quantityText: "", rawText: ingredient.rawText ?? "", note: "")
                        }
                    }
                }
            }
        }
        .task { @MainActor in
            servingSize = recipeService.selectedRecipe?.servingSize ?? 1
            ingredients = recipeService.selectedIngredients
        }
    }
}

struct RMIngredientItem: View {
    let imageName: String
    let quantityText: String
    let rawText: String
    let note: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                HStack {
                    Text(quantityText)
                        .bold()
                    Text(rawText)
                }
                Text(note)
            }
        }
    }
}

struct RMRecipeDetailMethod: View {
    @EnvironmentObject private var recipeService: RMRecipeService
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Method")
                .font(.title)
            let raw = recipeService.selectedRecipe?.methods ?? []
            var index = 1
            let methods = raw.map { step -> (Int, String) in
                if step.starts(with: "## ") {
                    index = 1
                    return (0, String(step.dropFirst("## ".count)))
                } else {
                    let value = (index, step)
                    index += 1
                    return value
                }
            }
            ForEach(Array(zip(methods.indices, methods)), id: \.0) { _, step in
                Group {
                    if step.0 < 1 {
                        Text(step.1)
                            .font(.title3)
                            .bold()
                            .padding(.vertical, 16)
                    } else {
                        VStack(alignment: .leading) {
                            Text("Step \(step.0)")
                                .bold()
                                .padding(.vertical, 8)
                            Text(step.1)
                        }
                    }
                }
            }
        }
    }
}

struct RMRecipeDetailTags: View {
    @EnvironmentObject private var recipeService: RMRecipeService
    
    var body: some View {
        Text("Tags")
            .font(.title)
        
        ScrollView(showsIndicators: false) {
            let raw = recipeService.selectedRecipe?.tags ?? []
            let tags = zip(raw.indices, raw)
                .map { index, tag in
                    Tag(id: index, tag: tag)
                }
            RMFlowLayout(tags) { tag in
                Text(tag.tag)
                    .foregroundColor(.black)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
            }
        }
    }
    
    private struct Tag: Identifiable, Hashable {
        let id: Int
        let tag: String
    }
}

struct RMRecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RMRecipeDetail()
    }
}
