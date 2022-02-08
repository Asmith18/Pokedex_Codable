//
//  Pokemon.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation

struct Pokedex: Decodable {
    let results: [PokedexResults]
    let next: String
}

struct PokedexResults: Decodable {
    let name: String
    let url: String
}

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let sprites: SpritePath
    let moves: [MovesDictionary]
}

struct SpritePath: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
    let backDefault: String
    let backFemale: String?
    let backShiny: String
    let backShinyFemale: String?
    let frontDefault: String
    let frontFemale: String?
    let frontShiny: String
    let frontShinyFemale: String?
}

struct MovesDictionary: Decodable {
    let move: Move
}

struct Move: Decodable {
    let name: String
}
