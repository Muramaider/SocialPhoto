//
//  FeedViewController+Extension.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 24/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//


import UIKit


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell" ) as! FeedTableViewCell
        
        cell.updatePost(with: fetchedPosts[indexPath.row])
        
        cell.likePressed = {
                [weak self, cell] postID, isLiked in

                let handler: (Result<Post>) -> Void = {
                    result in
                    switch result {
                    case .success(let newPost):
                        guard let index = self?.fetchedPosts.firstIndex(where: { $0.id == postID }) else {
                            assertionFailure("Inconsistent data")
                            return
                        }
                        DispatchQueue.main.async {
                            self?.fetchedPosts.remove(at: index)
                            self?.fetchedPosts.insert(PostClass.init(post: newPost), at: index)
                            
                            if cell.postID == newPost.id {
                                cell.updatePost(with: PostClass.init(post: newPost))
                            }
                        }
                    default:
//                        print("WRONG CHECK")
                        return
                    }
                }
        
                if isLiked {
                    ServiceManager.shared.unlikePost(postID: postID, completionHandler: handler)
                } else {
                    ServiceManager.shared.likePost(postID: postID, completionHandler: handler)
                }
                
            }
           
            cell.likesCountPressed = {
                [weak self] postID in
                
                let listViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listViewController") as! ListViewController
                    listViewController.listType = .usersLikedPost(postID: postID)
                
                self?.navigationController?.pushViewController(listViewController, animated: true)
            }
            
            cell.profilePressed = {
                [weak self] userID in

                 let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                profileViewController.userId = userID

                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
            
            cell.selectionStyle = .none

            return cell
    }
    
}

