//
//  UsersTableViewController.swift
//  MovieTracker
//
//  Created by Chantal Stangenberger on 17-01-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {
    
    var users = [Users]()
    let ref = Database.database().reference()
    let firebaseAuth = Auth.auth()
    
    // loads UsersTableViewController and calls function getUsers
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
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
    
    // checks for MovieTracker users in firebase
    func getUsers () {
        ref.child("users").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.users.removeAll()
            for data in snapshot.reversed() {
                guard let userDict = data.value as? Dictionary<String, AnyObject> else { return }
                let user = Users(key: data.key, data: userDict)
                self.users.append(user)
            }
            self.tableView.reloadData()
        })
    }
    
    // returns amount of MovieTracker users
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // returns tableview cell with data from firebase
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UsersTableViewCell
        cell?.emailLabel?.text = users[indexPath.row].email
        return cell!
    }
    
    // makes the background of the cell transparent
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    // adds uid of selected user from tableview to the globalstruct selectedUser
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalStruct.selectedUser = users[indexPath.row].uid
    }
    
    // sign out: sign user out and go to the log in page
    @IBAction func SignOutButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "SignOutSegue", sender: self)
        } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
          }
    }
}
