//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Serj on 16.06.2023.
//

import Foundation


// MARK: - Pokemon
struct Result: Codable {
    let results: [Pokemon]
}

// MARK: - Result
struct Pokemon: Codable {
    let name: String
    let url: String
}
