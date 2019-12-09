//
//  CoreDataManager.swift
//  SocialPhoto
//
//  Created by Vinogradov Alexey on 30/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import CoreData

class CoreDataWorker {
    
    struct CoreDataConst{
        static let modelName = "StoredPosts"
    }
    
    static let instance: CoreDataWorker = CoreDataWorker(modelName: CoreDataConst.modelName)
    
    private let modelName: String
    private init(modelName:String) {
        
        self.modelName = modelName
    }
    
    // CoreData init
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: CoreDataConst.modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error - \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergePolicy.overwrite
        
        return container
    }()
    
    func save(context: NSManagedObjectContext) {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error - \(error), \(error.userInfo)")
            }
        }
    }
    
    func createObject<T: NSManagedObject>(from entity: T.Type) -> T {
        
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        return object
    }
    
    func delete(object: NSManagedObject) {
        
        let context = getContext()
        context.delete(object)
        save(context: context)
    }
    
    func deleteAllData() {
        
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostStorage")
            fetchRequest.returnsObjectsAsFaults = false
            let context = getContext()
            do {
                let results = try context.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    context.delete(objectData)
                }
            } catch let error {
                print("Detele all data in PostStorage error :", error)
            }
    }
    
    func getContext() -> NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    func getEntity<T: NSManagedObject>(with id: String) -> T {
        
        let idPredicate = NSPredicate(format: "id == '\(id)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        
        let resultArray = fetchData(for: T.self, predicate: compoundPredicate)
        let result: T
        
        if resultArray.isEmpty {
            result = createObject(from: T.self)
        } else {
            result = resultArray.first!
        }
        
        return result
    }
    
    //For getting data of user
    func getEntity<T: NSManagedObject>(userid: String) -> [T] {
        
        let idPredicate = NSPredicate(format: "author == '\(userid)'")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        let sortDescriptor = NSSortDescriptor(key: "createdTime", ascending: false)
        
        let resultArray = fetchData(for: T.self, predicate: compoundPredicate, sortDescriptor: sortDescriptor)
        
        let result: [T]
        
        if resultArray.isEmpty {
            result = []
        } else {
            result = resultArray
        }
        
        return result
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        
        let context = getContext()
        let request: NSFetchRequest<T>
        var fetchResult = [T]()
        
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            request = NSFetchRequest(entityName: String(describing: entity))
        }
    
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            fetchResult = try context.fetch(request)
        } catch {
            debugPrint("ERROR!!! Could not fetch: \(error.localizedDescription)")
        }
        
        return fetchResult
    }
    
}
