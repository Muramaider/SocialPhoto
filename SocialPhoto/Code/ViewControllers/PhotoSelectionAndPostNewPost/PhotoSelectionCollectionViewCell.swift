//
//  PhotoSelectorCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 01/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class PhotoSelectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setPhoto(with image: UIImage) {
        photoImageView.image = image
    }
}
