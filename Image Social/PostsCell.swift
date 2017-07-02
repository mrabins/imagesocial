//
//  PostsCell.swift
//  Image Social
//
//  Created by Mark Rabins on 6/28/17.
//  Copyright © 2017 self.edu. All rights reserved.
//

import UIKit

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
    
    func configureCell(post: Post) {
        self.post = post
        self.captionTextView.text = post.caption
        self.likesLabel.text = "\(post.likes)"
    }
}
