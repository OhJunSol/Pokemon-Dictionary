//
//  PokemonLocationInfo.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

struct PokemonLocationInfo {
    let lat, lng: Double
    let id: Int
}

extension PokemonLocationInfo: Decodable {

    enum CodingKeys: String, CodingKey {
        case lat,lng,id
    }
}
