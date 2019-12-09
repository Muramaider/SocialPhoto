////
////  PostStorage+CoreDataProperties.swift
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
//public class PostStorage: NSManagedObject {
//    
//    @NSManaged public var id: String
//    @NSManaged public var author: String
//    @NSManaged public var descript: String
//    @NSManaged public var image: URL
//    @NSManaged public var createdTime: String
//    @NSManaged public var currentUserLikesThisPost: Bool
//    @NSManaged public var likeByCount: Int64
//    @NSManaged public var authorUsername: String
//    @NSManaged public var authorAvatar: URL
//    
//    @NSManaged public var user: UserStorage
//    
//}
//
//extension PostStorage {
//    private struct Const {
//        static let entityName = "PostStorage"
//        static let sortDescriptorKey = "createdTime"
//    }
//    
//    static var sortedFetchRequest: NSFetchRequest<PostStorage> {
//        let request = NSFetchRequest<PostStorage>(entityName: Const.entityName)
//        let sortDescriptor = NSSortDescriptor(key: Const.sortDescriptorKey, ascending: false)
//        request.sortDescriptors = [sortDescriptor]
//        request.resultType = .managedObjectResultType
//        return request
//    }
//    
//    
//    
//    @discardableResult
//    static func insertPost(into context: NSManagedObjectContext, post: Post) -> PostStorage {
//        
//        
//        let postToSave: PostStorage = context.insertObject()
//        
//        postToSave.id = post.id
//        postToSave.author = post.author
//        postToSave.descript = post.description
//        postToSave.image = post.image
//        postToSave.createdTime = post.createdTime
//        postToSave.currentUserLikesThisPost = post.currentUserLikesThisPost
//        postToSave.likeByCount = Int64(post.likedByCount)
//        postToSave.authorUsername = post.authorUsername
//        postToSave.authorAvatar = post.authorAvatar
//        
////        postToSave.user = userToSave
//        
//        return postToSave
//    }
//    
//}
//
