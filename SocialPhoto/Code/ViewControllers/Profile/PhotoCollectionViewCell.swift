//
//  PhotoCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 02/08/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageCell: UIImageView!

    func updatePostsOfUser(with post: PostClass) {
        imageCell.kf.setImage(with: post.image)
    }
    
}


