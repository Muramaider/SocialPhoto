//
//  ListTableViewCell.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 04/08/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateList(_ user: User) {
        iconImageView.kf.setImage(with: user.avatar)
        nameLabel.text = user.fullName
    }
    
}
