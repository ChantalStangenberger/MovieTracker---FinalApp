//
//  NowPlayingMoviesViewController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 15-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays the now playing movies in the cinema from The Movie Database.
//
//  Used https://www.youtube.com/watch?v=hPJaQ2Fh7Ao&t=206s for inspiration of working with a collectionview.
//

import UIKit

class NowPlayingMoviesViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieItems = [MovieItem]()
    
    // loads NowPlayingMoviesViewController and calls function updateUI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        ApiController.shared.fetchResults {
            (movieItems) in
            if let movieItems = movieItems {
                DispatchQueue.main.async {
                    self.updateUI(with: movieItems)
                }
            }
        }
    }
    
    // updates scene
    func updateUI(with movieItems: [MovieItem]) {
        DispatchQueue.main.async {
            self.movieItems = movieItems
            self.collectionView.reloadData()
        }
    }
    
    // retruns amount of movies
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieItems.count
    }
    
    // returns collectionview cell with data from the API
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        let baseImageLink = "https://image.tmdb.org/t/p/w500/"
        let completeImageLink = baseImageLink + movieItems[indexPath.row].image
        cell.ImageMovie.downloadedFrom(link: completeImageLink)
        return cell
    }
    
    // segue to MovieDetailViewController with details of the movies
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetail" {
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView.indexPath(for: cell)
            let movieItem = self.movieItems[(indexPath?.row)!]
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            movieDetailViewController.movieItem = movieItem
        }
    }
}

// downloads the image from the API: https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

