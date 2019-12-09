////
////  UserStorage+CoreDataClass.swift
////  Course4FinalTask
////
////  Created by Vinogradov Alexey on 11/11/2019.
////  Copyright © 2019 e-Legion. All rights reserved.
////
////
//
//import Foundation
//import CoreData
//
//
//public class UserStorage: NSManagedObject {
//   
//    @NSManaged public var userID: String
//    @NSManaged public var username: String
//    @NSManaged public var fullName: String
//    @NSManaged public var avatar: URL
//    @NSManaged public var followerscount: Int64
//    @NSManaged public var followingcount: Int64
//    @NSManaged public var currentUserFollowsThisUser: Bool
//    @NSManaged public var currentUserIsFollowedByThisUser: Bool
//    
//    @NSManaged public var post: PostStorage?
//
//}
//
//extension UserStorage {
//    private struct Const {
//        static let entityName = "UserStorage"
//        static let sortDescriptorKey = "userID"
//    }
//    
//    static var sortedFetchRequest: NSFetchRequest<UserStorage> {
//        let request = NSFetchRequest<UserStorage>(entityName: Const.entityName)
//        let sortDescriptor = NSSortDescriptor(key: Const.sortDescriptorKey, ascending: false)
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "userID CONTAINS[cd] '1'")])
//        request.predicate = predicate
//        request.sortDescriptors = [sortDescriptor]
//        request.resultType = .managedObjectResultType
//        return request
//    }
//    
//    @discardableResult
//    static func insertUser(into context: NSManagedObjectContext, user: User) -> UserStorage {
//        
//        let userToSave: UserStorage = context.insertObject()
//    
//        userToSave.userID = user.id
//        userToSave.username = user.username
//        userToSave.fullName = user.fullName
//        userToSave.avatar = user.avatar
//        userToSave.followerscount = Int64(user.followedByCount)
//        userToSave.followingcount = Int64(user.followsCount)
//        userToSave.currentUserFollowsThisUser = user.currentUserFollowsThisUser
//        userToSave.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
//        
//        return userToSave
//    }
//    
//    
//}
