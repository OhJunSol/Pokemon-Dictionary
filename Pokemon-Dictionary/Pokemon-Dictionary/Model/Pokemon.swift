//
//  Pokemon.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation

struct Pokemon {
    let id: Int
    let height: Int
    let name: String
    let weight: Int
    let sprites: Sprites
}

extension Pokemon: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, height, name, weight, sprites
    }
}
