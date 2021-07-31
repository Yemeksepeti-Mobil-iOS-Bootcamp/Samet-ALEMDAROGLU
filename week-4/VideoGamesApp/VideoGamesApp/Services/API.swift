//
//  API.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 17.07.2021.
//

import Foundation
import Alamofire

class API {
    
    let apiBaseUrl = APIConstants.apiEnv
    let apiKey = APIConstants.apiKey
    
    func getGames(completion: @escaping (GamesResponse) -> ()) {
        
        let endPoint = "/games"
        let requestUrl = "\(apiBaseUrl)\(endPoint)?key=\(apiKey)"
    
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        AF.request(url).response { (response) in
            guard let data = response.data else {
                return
            }
            
            do {
                let data = try JSONDecoder().decode(GamesResponse.self, from: data)
                completion(data)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getGameDetail(id: Int, completion: @escaping (GameDetail) -> ()) {
        
        let endPoint = "/games/\(id)?key=\(apiKey)"
        let requestUrl = "\(apiBaseUrl)\(endPoint)"
        
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        AF.request(url).response { (response) in
            guard let data = response.data else {
                return
            }
            do {
                let data = try JSONDecoder().decode(GameDetail.self, from: data)
                completion(data)
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
}
