//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 31/07/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import CoreData


class ProfileViewController: UIViewController {
    
    enum ProfileType {
        case currentUser
        case anotherUser
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var notificationToken: NSObjectProtocol?
    var profileType: ProfileType = .currentUser
    var refreshControl = UIRefreshControl()
    
    var userId: String?
    var posts: [PostClass] = []
    var user: UserClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        addRefreshControl()
        
        fetchData()
        
        notificationToken = NotificationCenter.default.addObserver(forName: .newPostWasPosted, object: nil, queue: .main) {
            notification in
            self.fetchData()

        }

    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumn: CGFloat = 3
        let width = collectionView.frame.size.width
        
        return CGSize(width: (width/numberOfColumn), height: (width/numberOfColumn))
    }
    
}

extension ProfileViewController {
   
    func fetchData(){
        if ServiceManager.shared.isOnline {
            getCurrentUser()
        }else{
            loadDataFromCoreData()
        }
    }
    
    func getCurrentUser() {

        Loader.instance.addShadowView()
        ServiceManager.shared.getUser() { result in
            switch result {
                
            case .success(let user):
                if self.userId == nil {
                    self.userId = user.id
                }
                
                if user.id == self.userId {
                    self.profileType = .currentUser
                    self.user = UserClass(user: user)
                    DispatchQueue.main.async {
                        self.navigationItem.title = user.username
                    }
                    self.findPostsFor(isCurrentUser: true, user: user)
                } else {
                    self.profileType = .anotherUser
                    guard let userID = self.userId else { return }
                    self.getAnotherUser(ID: userID)
                }
                
            case .fail(let error):
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    Alert.instance.showAlert(title: error)
                }
            
            }
        }
        
    }
    
    
    func findPostsFor(isCurrentUser: Bool, user: User) {
        
        ServiceManager.shared.getUserPosts(isCurrentUser: isCurrentUser, id: user.id) { result in
            switch result {
            
            case .success(let posts):
                self.posts = posts.compactMap({ (post) -> PostClass? in
                    return PostClass.init(post: post)
                })
                DispatchQueue.main.async {
                    self.posts.sort(by: { $0.createdTime > $1.createdTime })
                    self.collectionView.reloadData()
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
    
    func getAnotherUser(ID: String) {
        
        ServiceManager.shared.getAnotherUser(id: ID) { result in
            switch result {
                
                case .success(let user):
                    self.user = UserClass(user: user)
                    DispatchQueue.main.async {
                        self.navigationItem.title = user.username
                    }
                    self.findPostsFor(isCurrentUser: false, user: user)
                
                case .fail(let error):
                    DispatchQueue.main.async {
                        Loader.instance.removeShadowView()
                        Alert.instance.showAlert(title: error)
                    }
            
                }
        }
    }
    
     func loadDataFromCoreData(){
        Loader.instance.addShadowView()
        let usersFromCoreData = CoreDataWorker.instance.fetchData(for: UserStorage.self)
        print(usersFromCoreData.count)
        guard let userFromCoreData = CoreDataWorker.instance.fetchData(for: UserStorage.self).first, let user = UserClass(user: userFromCoreData) else {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                Loader.instance.removeShadowView()
            }
            return }
        self.user = user
        let postsFromCoreData:[PostStorage] = CoreDataWorker.instance.getEntity(userid: user.id)
        self.posts = postsFromCoreData.compactMap({
            (post) -> PostClass? in
            return PostClass.init(post: post)
        })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            Loader.instance.removeShadowView()
        }
    }
    
    // LOGOUT ПОЛЬЗОВАТЕЛЯ И ОБНУЛЕНИЕ ТОКЕНА
    @objc func logOutButtonTapped() {
        
        ServiceManager.shared.signOut() { result in
            
            switch result {
            case .success( _):
                _ = KeyChain.instance.deleteToken()
                //Change root to login view
                CoreDataWorker.instance.deleteAllData()
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                    let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "loginVC")
                    appDelegate.window?.rootViewController = loginVC
                    appDelegate.window?.makeKeyAndVisible()
                }
    
            case .fail(let error):
                DispatchQueue.main.async {
                    Alert.instance.showAlert(title: error)
                }
            }
            
        }
        
    }
    
    func addRefreshControl() {
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshContents), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    @objc func refreshContents() {
        fetchData()
        self.perform(#selector(finishedRefreshing), with: nil, afterDelay: 1.0)
    }
    
    @objc func finishedRefreshing() {
        refreshControl.endRefreshing()
    }
    @objc func timerFetch() {
        fetchData()
    }
    
}
