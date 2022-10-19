//
//  Resource + Pokemon.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

extension Resource {

    static func pokemon(id: Int) -> Resource<Pokemon> {
        let url = ApiConstants.pokemonUrl.appendingPathComponent("/\(id)")
        return Resource<Pokemon>(url: url)
    }
}
