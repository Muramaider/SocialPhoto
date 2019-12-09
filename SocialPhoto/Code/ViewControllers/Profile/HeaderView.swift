//
//  HeaderView.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 05/08/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderView: UICollectionReusableView {
    
    enum ProfileHeaderType {
        case currentUser
        case anotherUser
    }
    
    @IBOutlet weak var iconProfile: UIImageView!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton!
   
    
    var profileHeaderType: ProfileHeaderType = .currentUser
    var currentUserFollowsThisUser: Bool = false
    
    var followersPressed: (() -> Void)?
    var followingPressed: (() -> Void)?
    var followPressed: (() -> Void)?
    var unfollowPressed: (() -> Void)?
    
    @IBAction func followersButtonPressed(_ sender: Any) {
        followersPressed?()
    }
    @IBAction func followingButtonPressed(_ sender: Any) {
        followingPressed?()
    }
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        if currentUserFollowsThisUser {
            unfollowPressed?()
        } else {
            followPressed?()
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconProfile.layer.cornerRadius = iconProfile.frame.height/2
        iconProfile.clipsToBounds = true
        
        subscribeButton.layer.cornerRadius = 5.0
        subscribeButton.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
    }
    
    func configure(with user: UserClass, profileHeaderType: ProfileHeaderType) {
        iconProfile.kf.setImage(with: user.avatar)
        nameProfile.text = user.fullName
        followersButton.setTitle("Followers: \(user.followedByCount)", for: .normal)
        followingButton.setTitle("Following: \(user.followsCount)", for: .normal)
        followersButton.isEnabled = true
        followingButton.isEnabled = true
        self.profileHeaderType = profileHeaderType
        currentUserFollowsThisUser = user.currentUserFollowsThisUser
        updateSubscribeButton()
    }
    
    func configureEmptyState() {
        iconProfile.image = nil
        nameProfile.text = ""
        followersButton.setTitle("Followers:", for: .normal)
        followingButton.setTitle("Following:", for: .normal)
        followersButton.isEnabled = false
        followingButton.isEnabled = false
        currentUserFollowsThisUser = false
        self.profileHeaderType = .currentUser
        updateSubscribeButton()
    }
    
    func updateSubscribeButton() {
        if profileHeaderType == .currentUser {
            subscribeButton.isHidden = true
            subscribeButton.setTitle(" ", for: .normal)
        } else {
            if currentUserFollowsThisUser {
                subscribeButton.isHidden = false
                subscribeButton.setTitle("Unfollow", for: .normal)
            } else {
                subscribeButton.isHidden = false
                subscribeButton.setTitle("Follow", for: .normal)
            }
        }
    }

}
