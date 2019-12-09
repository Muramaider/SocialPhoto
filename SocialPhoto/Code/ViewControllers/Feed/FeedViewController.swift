//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 31/07/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import CoreData

class FeedViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    
    private var notificationToken: NSObjectProtocol?
    var fetchedPosts: [PostClass] = []
    var refreshControl = UIRefreshControl()
    var fetchingTimer: Timer?
    
//    //CORE DATASTACK
//
//    private var coreDataStack: ContextsStack = {
//          let stack = ContextsStack()
//          stack.createStack()
//          return stack
//    }()
//
//    fileprivate(set) lazy var fetchResultsController: NSFetchedResultsController<PostStorage> = {
//        let frc = NSFetchedResultsController(fetchRequest: PostStorage.sortedFetchRequest,
//                                             managedObjectContext: coreDataStack.viewContext,
//                                             sectionNameKeyPath: nil,
//                                             cacheName: nil)
//        frc.delegate = self
//        return frc
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
             addRefreshControl()
             feedPost()
             
             notificationToken = NotificationCenter.default.addObserver(forName: .newPostWasPosted, object: nil, queue: .main) {
                 notification in
                 self.feedPost()
                 self.tableView.contentOffset = CGPoint(x: 0, y: 0)
                 
             }
     //        fetchingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerFetch), userInfo: nil, repeats: true)
        
    }
    
}



//extension FeedViewController: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            guard let indexPath = newIndexPath else {
//                fatalError("Index path should be not nil")
//            }
//            tableView.insertRows(at: [indexPath], with: .left)
//        case .update:
//            guard let indexPath = indexPath else {
//                fatalError("Index path should be not nil")
//            }
//
//            let cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell
//            let post = fetchResultsController.object(at: indexPath)
//            cell?.configureStoredPost(with: post)
//        case .move:
//            guard let indexPath = indexPath else {
//                fatalError("Index path should be not nil")
//            }
//
//            guard let newIndexPath = newIndexPath else {
//                fatalError("New index path should be not nil")
//            }
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.insertRows(at: [newIndexPath], with: .fade)
//        case .delete:
//            guard let indexPath = indexPath else {
//                fatalError("Index path should be not nil")
//            }
//            tableView.deleteRows(at: [indexPath], with: .right)
//        @unknown default:
//            fatalError("UNKNOWN ERROR")
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//}


extension FeedViewController {
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: FeedTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FeedTableViewCell.self))
    }
    private func feedPost() {
        
        Loader.instance.addShadowView()
        if ServiceManager.shared.isOnline {
            
            ServiceManager.shared.feed() { result in
                
                switch result {
                case .success(let posts):
                    self.fetchedPosts = posts.compactMap({ (post) -> PostClass? in
                        return PostClass.init(post: post)
                    })

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        Loader.instance.removeShadowView()

                    }
                    
                case .fail(let error):
                    DispatchQueue.main.async {
                        Alert.instance.showAlert(title: error)
                        Loader.instance.removeShadowView()
                    }
                }
            }
            
        } else {
            let postsFromCoreData = CoreDataWorker.instance.fetchData(for: PostStorage.self, sortDescriptor: NSSortDescriptor(key: "createdTime", ascending: false))
            self.fetchedPosts = postsFromCoreData.compactMap({
                (post) -> PostClass? in
                return PostClass.init(post: post)
            })
            Loader.instance.removeShadowView()
        }
    }

    func addRefreshControl() {
        refreshControl.tintColor = UIColor.black
//        refreshControl.backgroundColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refreshContents), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refreshContents() {
        feedPost()
        self.perform(#selector(finishedRefreshing), with: nil, afterDelay: 1.0)
    }
    
    @objc func finishedRefreshing() {
        refreshControl.endRefreshing()
    }
    @objc func timerFetch() {
        feedPost()
    }
//    private func savePostsToStorage() {
//
//        UserService.sharedInstance.getUser() { [weak self] result in
//
//            switch result {
//            case.success(let user):
//                self?.findPostsForStored(user: user)
//            case.fail( _):
//                print("Can't save data")
//            }
//
//        }
//
//    }
//
//    private func findPostsForStored(user: User) {
//
//        PostService.sharedInstanse.getUserPosts(id: user.id) { [weak coreDataStack] result in
//
//            switch result {
//            case .success(let posts):
//                for post in posts {
//                    autoreleasepool {
//                        coreDataStack?.insertPost(post: post)
//                    }
//                }
//                DispatchQueue.main.async {
//                    coreDataStack?.saveChanges {}
//                }
//            case .fail(_):
//                print("Can't save data")
//            }
//
//        }
//    }
//
}


