//
//  ListViewViewController.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 04/08/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    
    enum ListType {
        case usersLikedPost(postID: String)
        case usersFollowedByUser(userID: String)
        case usersFollowingUser(userID: String)
        case staticList(users: [User])
    }
    
    var testUsers: [User] = []
    var listType: ListType = .staticList(users: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: FeedTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FeedTableViewCell.self))
       
        switcherOfLists()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switcherOfLists()
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
        
    }
    
}

extension ListViewController {
    
    func switcherOfLists() {
        switch listType {
        case .usersLikedPost(let postID):
            navigationItem.title = "Likes"
            getUsersLikedPost(postID: postID)
        case .usersFollowedByUser(let userID):
            navigationItem.title = "Following"
            getUserFollowers(userID: userID)
        case .usersFollowingUser(let userID):
            navigationItem.title = "Followers"
            getUsersFollowing(userID: userID)
        case .staticList(let users):
            self.testUsers = users
        }
    }
    
    func getUsersLikedPost(postID: String) {
        Loader.instance.addShadowView()
        ServiceManager.shared.usersLikeThisPost(id: postID) { result in
            switch result {
                
            case .success(let users):
                self.testUsers = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    Loader.instance.removeShadowView()
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    Alert.instance.showAlert(title: error)
                }
            }
        }
    }
    
    func getUserFollowers(userID: String) {
        
        Loader.instance.addShadowView()
        ServiceManager.shared.getFollowers(id: userID) { result in
           
            switch result {
                
            case .success(let users):
                self.testUsers = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    Loader.instance.removeShadowView()
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    Alert.instance.showAlert(title: error)
                }
            }
            
        }
        
    }
    
    func getUsersFollowing(userID: String) {
        
        Loader.instance.addShadowView()
        ServiceManager.shared.getFollowing(id: userID) { result in
            
            switch result {
                
            case .success(let users):
                self.testUsers = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    Loader.instance.removeShadowView()
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    Alert.instance.showAlert(title: error)
                }
            }

        }
        
    }
    
}
