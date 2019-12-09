//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 31/07/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var authorAvatarButton: UIButton!
    @IBOutlet private weak var nameLabel: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var discriptionLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var likeAmountButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    
    typealias LikeActionBlock = (String, Bool) -> Void
    typealias AmountofLikesActionBlock = ((_ postID: String) -> Void)
    typealias ProfileActionBlock = ((_ userID: String) -> Void)

    var likePressed: LikeActionBlock?
    var likesCountPressed: AmountofLikesActionBlock?
    var profilePressed: ProfileActionBlock?
    
    private var currentUserLikesThisPost = false
    private var authorID: String = ""
    var postID: String = ""
    
    override func awakeFromNib() {
        authorAvatarButton.layer.cornerRadius = authorAvatarButton.frame.height/2
        authorAvatarButton.clipsToBounds = true
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        likeAmountButton.addTarget(self, action:#selector(likesCountButtonPressed), for: .touchUpInside)
        nameLabel.addTarget(self, action:#selector(profileNamePressed), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
        tap.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tap)
    }
    
    @objc private func doubleTapHandler() {
        if !currentUserLikesThisPost {
            likePressed?(postID, false)
        }
        let bigLikeImageView = UIImageView(image: UIImage(named: "bigLike"))
        bigLikeImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.addSubview(bigLikeImageView)
        
        bigLikeImageView.centerXAnchor.constraint(equalTo: postImageView.centerXAnchor).isActive = true
        bigLikeImageView.centerYAnchor.constraint(equalTo: postImageView.centerYAnchor).isActive = true
        bigLikeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        bigLikeImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bigLikeImageView.alpha = 0.0
        
        let completion: (Bool) -> Void = {
            _ in

            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
                bigLikeImageView.alpha = 0
            }, completion: { _ in
                bigLikeImageView.removeFromSuperview()
            })
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            bigLikeImageView.alpha = 1.0
        }, completion: completion)
        
        
    }
    
    @objc private func likeButtonPressed(_ sender: UIButton) {
        likePressed?(postID, currentUserLikesThisPost)
    }
    
    @objc private func likesCountButtonPressed(_ sender: UIButton) {
        likesCountPressed?(postID)
    }
    
    @objc private func profileNamePressed(_ sender: UIButton) {
         profilePressed?(authorID)
    }
    
    @IBAction private func profileButtonPressed(_ sender: UIButton) {
        profilePressed?(authorID)
    }

    func updatePost(with post: PostClass) {
        authorAvatarButton.kf.setImage(with: post.authorAvatar, for: .normal)
        nameLabel.setTitle(post.authorUsername, for: .normal)
        dateLabel.text = datePicker(data: post.createdTime)
        postImageView.kf.setImage(with: post.image)
        discriptionLabel.text = post.description
        likeAmountButton.setTitle("Likes: \(post.likedByCount)", for: .normal)
        setLikeColor(isLiked: post.currentUserLikesThisPost)
   
        postID = post.id
        currentUserLikesThisPost = post.currentUserLikesThisPost
        authorID = post.author
    }
    
//    func configureStoredPost(with post: PostStorage) {
//        authorAvatarButton.kf.setImage(with: post.authorAvatar, for: .normal)
//        nameLabel.setTitle(post.user.fullName, for: .normal)
//        dateLabel.text = datePicker(data: post.createdTime)
//        postImageView.kf.setImage(with: post.image)
//        discriptionLabel.text = post.discript
//        likeAmountButton.setTitle("Likes: \(post.likeByCount)", for: .normal)
//        setLikeColor(isLiked: post.currentUserLikesThisPost)
//        
//        postID = post.id
//        currentUserLikesThisPost = post.currentUserLikesThisPost
//        authorID = post.user.userID
//    }
    
    private func setLikeColor(isLiked: Bool) {
        if isLiked {
            likeButton.tintColor = .blue
        } else {
            likeButton.tintColor = .lightGray
        }
    }
    
    private func datePicker(data: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"
        guard let date = dateFormatter.date(from: data) else { return "ERROR TYPE" }
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        return dateFormatter.string(from: date)
    }
 
}

