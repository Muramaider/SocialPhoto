//
//  UserClass.swift
//  SocialPhoto
//
//  Created by Vinogradov Alexey on 30/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class UserClass {
    
    let id: String
    let userName: String
    let fullName: String
    let avatar: URL
    let currentUserFollowsThisUser: Bool
    let currentUserIsFollowedByThisUser: Bool
    let followsCount: Int
    let followedByCount: Int
    
    init?(user: UserStorage){
        guard let id = user.id, let username = user.username, let fullName = user.fullName, let avatar = user.avatar else {return nil}
        
        self.id = id
        self.userName = username
        self.fullName = fullName
        self.avatar = avatar
        self.currentUserFollowsThisUser = user.currentUserFollowsThisUser
        self.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
        self.followsCount = Int(user.followsCount)
        self.followedByCount = Int(user.followedByCount)
    }
    
    init(user: User){
        self.id = user.id
        self.userName = user.username
        self.fullName = user.fullName
        self.avatar = user.avatar
        self.currentUserFollowsThisUser = user.currentUserFollowsThisUser
        self.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
        self.followsCount = user.followsCount
        self.followedByCount = user.followedByCount
    }
}
