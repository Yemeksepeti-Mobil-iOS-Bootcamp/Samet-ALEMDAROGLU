//
//  Movie.swift
//  MovieApp
//
//  Created by ALEMDAR on 22.07.2021.
//

import Foundation

struct Movie: Decodable {
    var id: Int?
    var poster: String?
    var name:String?

    enum CodingKeys: String, CodingKey {
        case id
        case poster = "poster_path"
        case name = "original_title"
    }
}


