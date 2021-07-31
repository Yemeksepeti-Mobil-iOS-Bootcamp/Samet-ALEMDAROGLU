//
//  MovieResponse.swift
//  MovieApp
//
//  Created by ALEMDAR on 22.07.2021.
//

import Foundation

struct MovieResponse: Decodable {
    var movies: [Movie]?

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

