//
//  RMIngredient.swift
//  ReciMeChallenge
//
//  Created by henry on 24/01/2023.
//

import Foundation

struct RMIngredent: Codable {
    let heading: String?
    let id: Int?
    let product: String?
    var quantity: Double?
    let unit, productModifier, preparationNotes, imageFileName: String?
    let rawText, rawProduct: String?
    let measurement: RMMeasurement?
    let preProcessedText: String?
}

extension RMIngredent {
    mutating func increaseServe(_ serve: Double) {
        if var quantity = self.quantity {
            quantity += (serve + 1)/serve
            self.quantity = quantity
        }
    }
    
    mutating func decreaseServe(_ serve: Double) {
        if var quantity = self.quantity {
            quantity -= (serve - 1)/serve
            self.quantity = quantity
        }
    }
}

struct RMMeasurement: Codable {
    let measurement, sys, category, plural: String?
}
