//
//  Resource + PokemonLocations.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

extension Resource {

    static func pokemonLocations() -> Resource<PokemonLocationsResponse> {
        let url = ApiConstants.pokemonLocationUrl
        return Resource<PokemonLocationsResponse>(url: url)
    }
}
