//
//  PokemonLocationsResponse.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

struct PokemonLocationsResponse {
    let pokemonLocationInfos: [PokemonLocationInfo]
}

extension PokemonLocationsResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case pokemonLocationInfos = "pokemons"
    }
}
