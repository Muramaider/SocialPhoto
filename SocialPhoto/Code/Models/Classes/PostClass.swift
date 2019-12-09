//
//  PostClass.swift
//  SocialPhoto
//
//  Created by Vinogradov Alexey on 30/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class PostClass {
    
    let id: String
    let author: String
    let description: String
    let image: URL
    let createdTime: String
    let currentUserLikesThisPost: Bool
    let likedByCount: Int
    let authorUsername: String
    let authorAvatar: URL
    
    init?(post: PostStorage){
        guard let id = post.id, let author = post.author, let image = post.image, let createdTime = post.createdTime, let authorUsername = post.authorUsername, let authorAvatar = post.authorAvatar, let descript = post.descript  else {return nil}
        self.id = id
        self.author = author
        self.description = descript
        self.image = image
        self.createdTime = createdTime
        self.currentUserLikesThisPost = post.currentUserLikesThisPost
        self.likedByCount = Int(post.likeByCount)
        self.authorUsername = authorUsername
        self.authorAvatar = authorAvatar
    }
    
    init(post: Post){
        self.id = post.id
        self.author = post.author
        self.description = post.description
        self.image = post.image
        self.createdTime = post.createdTime
        self.currentUserLikesThisPost = post.currentUserLikesThisPost
        self.likedByCount = post.likedByCount
        self.authorUsername = post.authorUsername
        self.authorAvatar = post.authorAvatar
    }
}
