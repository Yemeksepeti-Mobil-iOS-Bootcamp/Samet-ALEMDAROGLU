//
//  Game.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 17.07.2021.
//

import Foundation

struct Game: Decodable {
    var id: Int?
    var name: String?
    var released: String?
    var image: String?
    var rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case image = "background_image"
        case rating
    }
}
