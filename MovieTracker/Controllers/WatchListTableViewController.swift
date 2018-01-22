//
//  WatchListTableViewController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 17-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
// Used https://grokswift.com/transparent-table-view/ to get a transparant tableview
//

import UIKit
import Firebase

class WatchListTableViewController: UITableViewController {
    
    var movies = [Movies]()
    let ref = Database.database().reference()

    // loads WatchListTableViewController and calls function getMovies
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = true
        getMovies()
    }
    
    // some preferences for the layout
    override func viewDidAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "background.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        tableView.separatorStyle = .none
    }
    
    // checks for currents user data (movies) in firebase
    func getMovies () {
        let userId = Auth.auth().currentUser?.uid
        ref.child("movies").child(userId!).observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.movies.removeAll()
            for data in snapshot.reversed() {
                guard let movieDict = data.value as? Dictionary<String, AnyObject> else { return }
                let movie = Movies(movieKey: data.key, movieData: movieDict)
                self.movies.append(movie)
            }
            self.tableView.reloadData()
        })
    }
    
    // returns amount of movies in personal watch list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // returns tableview cell with data from firebase
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchListCell", for: indexPath) as? WatchListTableViewCell
        cell?.movieDescription?.text = movies[indexPath.row].movieDescription
        cell?.movieTitle?.text = movies[indexPath.row].movieTitle
        let baseImageLink = "https://image.tmdb.org/t/p/w500/"
        let completeImageLink = baseImageLink + movies[indexPath.row].movieImage
        cell?.imageWatch.downloadedFrom(link: completeImageLink)

        return cell!
    }
    
    // makes the background of the cell transparent
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    // enables edditing rows
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // if row is deleted: remove movie from firebase and delete movie from tableview
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let userId = Auth.auth().currentUser?.uid
            if editingStyle == .delete {
                self.ref.child("movies").child(userId!).child(self.movies[indexPath.row].movieTitle).removeValue()
                self.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
    }
}


