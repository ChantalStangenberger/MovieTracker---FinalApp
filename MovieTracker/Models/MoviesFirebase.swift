//
//  MoviesFirebase.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 19-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//  https://www.youtube.com/watch?v=cpSa1p1RUvE&t=16s
//

import Foundation
import Firebase

class Movies {
    private var _movieTitle: String!
    private var _movieImage: String!
    private var _movieDescription: String!
    private var _movieKey:  String!
    private var _movieRef: DatabaseReference!
    
    var movieTitle: String {
        return _movieTitle
    }
    
    var movieImage: String {
        return _movieImage
    }
    
    var movieDescription: String {
        return _movieDescription
    }
    
    var movieKey: String {
        return _movieKey
    }
    
    init(movieDescription: String, movieTitle: String, movieImage: String) {
        _movieDescription = movieDescription
        _movieTitle = movieTitle
        _movieImage = movieImage
    }
    
    init(movieKey: String, movieData: Dictionary<String, AnyObject>) {
        _movieKey = movieKey
        
        if let movieTitle = movieData["movieTitle"] as? String {
            _movieTitle = movieTitle
        }
        
        if let movieImage = movieData["movieImage"] as? String {
            _movieImage = movieImage
        }
        
        if let movieDescription = movieData["movieDescription"] as? String {
            _movieDescription = movieDescription
        }
        
        _movieRef = Database.database().reference().child("movie").child(_movieKey)
    }
}
