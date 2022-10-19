//
//  PokemonNamesResponse.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

struct PokemonNamesResponse {
    let pokemonNameInfos: [PokemonNameInfo]
}

extension PokemonNamesResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case pokemonNameInfos = "pokemons"
    }
}
