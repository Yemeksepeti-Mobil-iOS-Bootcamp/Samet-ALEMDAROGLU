//
//  APIConstants.swift
//  MovieApp
//
//  Created by ALEMDAR on 22.07.2021.
//

import Foundation

struct APIConstants {
    static let apiEnv = APIEnvironment.Dev.rawValue
    static let apiKey = APIConfig.devKey.rawValue
    
}

enum APIEnvironment: String{
    case Dev = "https://api.themoviedb.org"
    case Prod = ""
}

enum APIConfig : String {
    case devKey = "158a13606cb830fceb663df5d06de5cc"
    case prodKey = ""
}
