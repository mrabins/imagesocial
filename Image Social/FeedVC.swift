//
//  FeedVC.swift
//  Image Social
//
//  Created by Mark Rabins on 6/28/17.
//  Copyright © 2017 self.edu. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for  snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postId: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.feedTableView.reloadData()
        })
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension FeedVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = feedTableView.dequeueReusableCell(withIdentifier: "feedCell") as? PostsCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return PostsCell()
        }
    }
    
}

extension FeedVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375.0
    }
    
}
