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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
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
        
    }
}
