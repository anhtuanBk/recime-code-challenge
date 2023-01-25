//
//  RMRecipeList.swift
//  ReciMeChallenge
//
//  Created by henry on 24/01/2023.
//

import SwiftUI

struct RMRecipeList: View {
    @EnvironmentObject var recipeService: RMRecipeService
    
    var body: some View {
        Group {
            if recipeService.isLoading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ],
                              spacing: 16) {
                        ForEach(recipeService.recipes) { recipe in
                            RMRecipeItem(imageUrl: recipe.imageURL ?? "", title: recipe.title ?? "", time: recipe.cookTime, saves: recipe.numSaves)
                                .aspectRatio(0.67, contentMode: .fill)
                                .onTapGesture {
                                    recipeService.seletedRecipeId = recipe.id
                                }
                        }
                    }
                              .padding(16)
                }
            }
        }
        .sheet(item: $recipeService.selectedRecipe) { _ in
            RMRecipeDetail()
        }
    }
}

struct RMRecipeItem: View {
    let imageUrl: String
    let title: String
    let time: Int?
    let saves: Int?
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                CachedAsyncImage(url: URL(string: imageUrl), content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }, placeholder: {
                    ProgressView()
                })
                .frame(width: geo.size.width)
                .frame(maxHeight: .infinity)
                .cornerRadius(16)
                .clipped()
                .overlay(alignment: .bottom) {
                    HStack {
                        if let time {
                            Text("\(time)m")
                        }
                        Spacer()
                        if let saves {
                            Text("\(saves)")
                        }
                    }
                    .padding(8)
                }
                
                Text(title)
            }
        }
    }
}

struct RMRecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RMRecipeList()
            .environmentObject(RMRecipeService())
    }
}
