////
////  ContextStack.swift
////  Course4FinalTask
////
////  Created by Vinogradov Alexey on 09/11/2019.
////  Copyright © 2019 e-Legion. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//class ContextsStack {
//    
//    struct Const {
//        static let dataModelName = "StoredPosts"
//    }
//    
//    typealias NotificationClosure = (_ notification: Notification) -> Void
//    typealias SaveCompletionClosure = () -> Void
//    
//    fileprivate(set) var persistentContainer: NSPersistentContainer
//    var viewContext: NSManagedObjectContext!
//    var backgroundContext: NSManagedObjectContext!
//    
//    // MARK: - Init
//    
//    init() {
//        persistentContainer = NSPersistentContainer(name: Const.dataModelName)
////        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
////            if let error = error as NSError? {
////                fatalError("Unresolved error - \(error), \(error.userInfo)")
////            }
////        })
////        persistentContainer.viewContext.mergePolicy = NSMergePolicy.overwrite
//    }
//    
//    // MARK: - CoreDataStack
//    
//    func createStack() {
//
//        persistentContainer.loadPersistentStores { [weak self] (_, error) in
//            guard error == nil else {
//                fatalError("Failed to load store: \(error!)")
//            }
//            self?.viewContext = self?.persistentContainer.viewContext
//            self?.backgroundContext = self?.persistentContainer.newBackgroundContext()
//            
//            let notificationClosure: NotificationClosure = { [weak self] notification in
//                self?.viewContext.performMergeChangesFromContextDidSaveNotification(notification: notification)
//            }
//            
//            NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
//                                                   object: self?.backgroundContext,
//                                                   queue: nil,
//                                                   using: notificationClosure)
//        }
//    }
//    
////    func insertPost(post: Post) {
////        backgroundContext.performChanges {
////            PostStorage.insertPost(into: self.backgroundContext, post: post)
////        }
////    }
////    
////    func insertUser(user: User) {
////        backgroundContext.performChanges {
////            UserStorage.insertUser(into: self.backgroundContext, user: user)
////        }
////    }
//    
////    func clearAllPosts() {
////        backgroundContext.performChanges {
////            guard let posts = try? self.backgroundContext.fetch(PostStorage.sortedFetchRequest) else {
////                return
////            }
////
////            posts.forEach { self.backgroundContext.delete($0) }
////        }
////    }
////
////    func clearAllInUser() {
////        backgroundContext.performChanges {
////            guard let posts = try? self.backgroundContext.fetch(UserStorage.sortedFetchRequest) else {
////                return
////            }
////
////            posts.forEach { self.backgroundContext.delete($0) }
////        }
////    }
//    
//    func saveChanges(completion: @escaping SaveCompletionClosure) {
//        backgroundContext.saveOrRollback {
//            completion()
//        }
//    }
//    
//    
//    func getEntity<T: NSManagedObject>(userid: String) -> [T] {
//        let idPredicate = NSPredicate(format: "author == '\(userid)'")
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
//        
//        let resultArray = fetchData(for: T.self, predicate: compoundPredicate)
//        let result: [T]
//        
//        
//        if resultArray.isEmpty {
//            result = []
//        } else {
//            result = resultArray
//        }
//        
//        return result
//    }
//    
//    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
//        let context = persistentContainer.viewContext
//        let request: NSFetchRequest<T>
//        
//        var fetchResult = [T]()
//        
//        if #available(iOS 10.0, *) {
//            request = entity.fetchRequest() as! NSFetchRequest<T>
//        } else {
//            request = NSFetchRequest(entityName: String(describing: entity))
//        }
//        
//        if let predicate = predicate {
//            request.predicate = predicate
//        }
//        
//        if let sortDescriptor = sortDescriptor {
//            request.sortDescriptors = [sortDescriptor]
//        }
//        
//        do {
//            fetchResult = try context.fetch(request)
//        } catch {
//            debugPrint("ERROR!!! Could not fetch: \(error.localizedDescription)")
//        }
//        
//        return fetchResult
//    }
//}
//
