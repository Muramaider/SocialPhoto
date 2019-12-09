//
//  PostModel.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 13/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation


struct Post: Decodable {
    
    var id: String
    var author: String
    var description: String
    var image: URL
    var createdTime: String
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
    var authorUsername: String
    var authorAvatar: URL
    
}
