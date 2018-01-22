//
//  ApiController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 16-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import Foundation

class ApiController {
    
    static let shared = ApiController()
    static let apiKey: String = "98089d8ab191469f8d806cef6521af13"
    
    func fetchResults(completion: @escaping ([MovieItem]?) -> Void) {
        let url = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(ApiController.apiKey)")!)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let movieItems = try? jsonDecoder.decode(MovieItems.self, from: data) {
                completion(movieItems.results)
            } else {
                completion(nil)
                print("fail")
            }
        }
        task.resume()
    }
}
