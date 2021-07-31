//
//  MovieDetail.swift
//  MovieApp
//
//  Created by ALEMDAR on 23.07.2021.
//

import Foundation

struct MovieDetail: Decodable {
    var id: Int?
    var poster: String?
    var name: String?
    var description: String?
    var voteCount: Int?
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case poster = "poster_path"
        case name = "original_title"
        case description = "overview"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
    }
}
