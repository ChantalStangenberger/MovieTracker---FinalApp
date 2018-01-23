//
//  UserWatchListTableViewController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 21-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase

class UserWatchListTableViewController: UITableViewController {
    
    let ref = Database.database().reference()
    var userMovies = [Movies]()
    
    // loads UserWatchListTableViewController with some preferences for the layout and calls function getUsersMovies
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "background.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        tableView.separatorStyle = .none
        
        getUserMovies()
    }
    
    // checks for data (movies) of the selectedUser in firebase
    func getUserMovies () {
        ref.child("movies").child(globalStruct.selectedUser).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.userMovies.removeAll()
            for data in snapshot.reversed() {
                guard let movieDict = data.value as? Dictionary<String, AnyObject> else { return }
                let movie = Movies(movieKey: data.key, movieData: movieDict)
                self.userMovies.append(movie)
            }
            self.tableView.reloadData()
        })
    }

    // returns amount of movies in selectedUsers watch list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMovies.count
    }
    
     // returns tableview cell with data from firebase
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserWatchListCell", for: indexPath) as? WatchListTableViewCell
        cell?.movieDescription?.text = userMovies[indexPath.row].movieDescription
        cell?.movieTitle?.text = userMovies[indexPath.row].movieTitle
        let baseImageLink = "https://image.tmdb.org/t/p/w500/"
        let completeImageLink = baseImageLink + userMovies[indexPath.row].movieImage
        cell?.imageWatch.downloadedFrom(link: completeImageLink)
        
        return cell!
    }
    
    // makes the background of the cell transparent
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
