//
//  MovieDetailViewController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 16-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays the movies details from The Movie Database and allows users to add movies to their watchlist.
//

import UIKit
import Firebase

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movieItem: MovieItem!
    let ref = Database.database().reference()
    
    // loads MovieDetailViewController and calls function updateUI
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        descriptionLabel.sizeToFit()
    }
    
    // updates scene
    func updateUI() {
        titleLabel.text = movieItem.title
        descriptionLabel.text = movieItem.description
        let baseImageLink = "https://image.tmdb.org/t/p/w500/"
        let completeImageLink = baseImageLink + movieItem.image
        imageView.downloadedFrom(link: completeImageLink)
    }
   
    // add button: adds movie to watch list of current user, if the watchlist already contains the movie an alert message show up.
    @IBAction func AddToWatchListButtonTapped(_ sender: AnyObject) {
        let userId = Auth.auth().currentUser?.uid
        ref.child("movies").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(self.movieItem.title) {
                let alert = UIAlertController(title: "Whoops!", message: "Movie already added to personal watch list!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let movie = ["movieTitle": self.titleLabel.text! as String,
                             "movieDescription": self.descriptionLabel.text! as String,
                             "movieImage": self.movieItem.image as String
                             ]
                let firebaseMovies = self.ref.child("movies").child(userId!).child(self.movieItem.title)
                firebaseMovies.setValue(movie)
            }
        })
    }
}

