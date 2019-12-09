////
////  NSManagedObjectContext+Extension.swift
////  Course4FinalTask
////
////  Created by Vinogradov Alexey on 09/11/2019.
////  Copyright © 2019 e-Legion. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//extension NSManagedObjectContext {
//    typealias PerformChangesClosure = () -> Void
//   
//    func insertObject<T: NSManagedObject>() -> T {
//        guard let entityName = T.entity().name,
//            let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self) as? T else {
//                  fatalError("can't insert object")
//        }
//        
//        return object
//    }
//   
//    func performChanges(block: @escaping PerformChangesClosure) {
//        perform {
//            block()
//        }
//    }
//    
//    func saveOrRollback(completion: @escaping () -> ()) {
//        perform {
//            defer { completion() }
//            self.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//            if !self.hasChanges {
//                return
//            }
//            
//            do {
//                print("start saving in \(Thread.isMainThread ? "view" : "background") context")
//                try self.save()
//                print("changes saved successfully in \(Thread.isMainThread ? "view" : "background") context")
//            } catch {
//                self.rollback()
//                print("Error: \(error) saving changes failed in \(Thread.isMainThread ? "view" : "background") context")
//            }
//        }
//    }
//    
//    func performMergeChangesFromContextDidSaveNotification(notification: Notification) {
//        perform {
//            print("start merge in \(Thread.isMainThread ? "view" : "background") context")
//            self.mergeChanges(fromContextDidSave: notification)
//            print("end merge in \(Thread.isMainThread ? "view" : "background") context")
//        }
//    }
//}
//
