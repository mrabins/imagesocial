//
//  PostsCell.swift
//  Image Social
//
//  Created by Mark Rabins on 6/28/17.
//  Copyright © 2017 self.edu. All rights reserved.
//

import UIKit
import Firebase

class PostsCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likes: UIImageView!
    
    var post: Post!
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
        tap.numberOfTapsRequired = 1
        likes.addGestureRecognizer(tap)
        likes.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postId)
        
        self.captionTextView.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
        if image != nil {
            self.postImage.image = image
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from FIRStorage")
                } else {
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postImage.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
                
            })
        }
        
        likesFromFirebase(noLikes: "empty-heart", yesLikes: "filled-heart")
    }
    
    func likesFromFirebase(noLikes: String, yesLikes: String) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likes.image = UIImage(named: noLikes)
            } else {
                self.likes.image = UIImage(named: yesLikes)
            }
        })
    }
    
        func likesTapped(sender: UITapGestureRecognizer) {
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.likesFromFirebase(noLikes: "filled-heart", yesLikes: "")
                    self.post.adjustLikes(addLike: true)
                    self.likesRef.setValue(true)
                } else {
                    self.likesFromFirebase(noLikes: "", yesLikes: "empty-heart")
                    self.post.adjustLikes(addLike: false)
                    self.likesRef.removeValue()
                }
            })
        }
    }

