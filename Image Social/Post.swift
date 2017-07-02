//
//  Post.swift
//  Image Social
//
//  Created by Mark Rabins on 7/1/17.
//  Copyright © 2017 self.edu. All rights reserved.
//

import Foundation

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postId: String!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postId: String {
        return _postId
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postId: String, postData: Dictionary<String, AnyObject>) {
        self._postId = postId
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
    }
}
