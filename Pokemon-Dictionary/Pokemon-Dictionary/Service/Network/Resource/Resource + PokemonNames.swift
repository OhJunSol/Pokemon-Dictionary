//
//  Resource + PokemonNames.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

extension Resource {

    static func pokemonNames() -> Resource<PokemonNamesResponse> {
        let url = ApiConstants.pokemonNameUrl
        return Resource<PokemonNamesResponse>(url: url)
    }
}
