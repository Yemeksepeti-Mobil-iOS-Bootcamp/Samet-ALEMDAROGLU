//
//  Games.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 17.07.2021.
//

import Foundation

struct GamesResponse: Decodable {
    var games: [Game]?
    
    enum CodingKeys: String, CodingKey {
        case games = "results"
    }
}

