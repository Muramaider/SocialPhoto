//
//  ProfileViewController+Extension.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 25/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        cell.updatePostsOfUser(with: posts[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! HeaderView
        guard let user = self.user else {
            header.configureEmptyState()
            
            return header
        }
        
        if case .currentUser = profileType {
            header.configure(with: user, profileHeaderType: .currentUser)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTapped))
        } else {
            header.configure(with: user, profileHeaderType: .anotherUser)
        }
        
        header.followingPressed = {
            [weak self] in
            let listViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listViewController") as! ListViewController
            listViewController.listType = .usersFollowingUser(userID: user.id)
            self?.navigationController?.pushViewController(listViewController, animated: true)
            
        }
        
        header.followersPressed = {
            [weak self] in
            let listViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listViewController") as! ListViewController
            listViewController.listType = .usersFollowedByUser(userID: user.id)
            self?.navigationController?.pushViewController(listViewController, animated: true)
                
            }
        let handler: (Result<User>) -> Void = {
            result in
            switch result {
                
            case .success(let newUser):
                let user = UserClass(user: newUser)
                self.user = user
                DispatchQueue.main.async {
                    header.configure(with: user, profileHeaderType: .anotherUser)
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    Alert.instance.showAlert(title: error)
                }

            }
        }
        header.followPressed = {
            ServiceManager.shared.follow(id: user.id, completionHandler: handler)
        }
        
        header.unfollowPressed = {
            ServiceManager.shared.unfollow(id: user.id, completionHandler: handler)
        }
        
        return header
    }

}
