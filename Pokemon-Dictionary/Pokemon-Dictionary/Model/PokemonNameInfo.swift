//
//  PokemonNameInfo.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

struct PokemonNameInfo {
    let id: Int
    let names: [String]
}

extension PokemonNameInfo: Decodable {

    enum CodingKeys: String, CodingKey {
        case id,names
    }
}
