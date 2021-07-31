//
//  API.swift
//  MovieApp
//
//  Created by ALEMDAR on 22.07.2021.
//

import Foundation

class API {
    
    private let apiBaseUrl = APIConstants.apiEnv
    private let apiKey = APIConstants.apiKey
    
    func getMoviesData(page: Int, completion: @escaping(MovieResponse) -> ()){
    
        let endPoint = "/3/movie/popular"
        var requestUrl = "\(apiBaseUrl)\(endPoint)?"
        let params = [
            "api_key": "\(apiKey)",
            "page": "\(page)"
        ]
        
        for param in params {
            requestUrl.append("\(param.key)=\(param.value)&")
        }
        requestUrl.removeLast()
        
        guard let url = URL(string: requestUrl) else {
            print("URL could not created")
            return
        }
 
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("Data could not created")
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(movieResponse)
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getMovieDetail(id: Int, completion: @escaping(MovieDetail) -> ()) {
        
        let endPoint = "/3/movie/\(id)"
        var requestUrl = "\(apiBaseUrl)\(endPoint)?"
        let params = [
            "api_key": "\(apiKey)"
        ]
        
        for param in params {
            requestUrl.append("\(param.key)=\(param.value)&")
        }
        requestUrl.removeLast()
        
        guard let url = URL(string: requestUrl) else {
            print("URL could not created")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("Data could not created")
                return
            }
            
            do {
                let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(movieDetail)
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
}
