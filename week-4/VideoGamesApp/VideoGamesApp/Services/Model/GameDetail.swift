//
//  GameDetailResponse.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 19.07.2021.
//

import Foundation

struct GameDetail: Decodable {
    var id: Int?
    var name: String?
    var description: String?
    var metacritic: Int?
    var released: String?
    var image: String?
    var rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case metacritic
        case released
        case image = "background_image"
        case rating
    }
}

