//
//  UserModel.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 13/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation


struct User: Decodable {

    var id: String
    var username: String
    var fullName: String
    var avatar: URL
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
    
}
