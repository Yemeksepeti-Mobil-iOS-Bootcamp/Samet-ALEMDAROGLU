//
//  APIConstans.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 17.07.2021.
//

import Foundation

struct APIConstants {
    static let apiEnv: String = APIEnvironment.Dev.rawValue
    static let apiKey: String = APIConfig.devKey.rawValue
}

enum APIEnvironment: String {
    case Prod = ""
    case Dev = "https://api.rawg.io/api"
}

enum APIConfig: String {
    case prodKey = ""
    case devKey = "a60edca37d7d433b80ba4bacfc155b7f"
}

