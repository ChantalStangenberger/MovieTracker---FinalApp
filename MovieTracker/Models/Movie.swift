//
//  Movie.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 16-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Model to represent the server data.
//

import Foundation

struct MovieItem: Codable {
    var title: String
    var image: String
    var description: String
    
        enum CodingKeys: String, CodingKey {
            case title
            case image = "poster_path"
            case description = "overview"
        }
}

struct MovieItems: Codable {
    let results: [MovieItem]
}
