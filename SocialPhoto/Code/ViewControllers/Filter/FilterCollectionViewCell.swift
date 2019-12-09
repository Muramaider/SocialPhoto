//
//  FilterCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 01/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    let filterProvider = FilterProvider.init()
    let queue = OperationQueue()
   
    func setFilterToCell(with image: UIImage?, filterName: String) {

        filterNameLabel.text = filterName

        let operation = FilterImageOperation(inputImage: image, chosenFilter: filterName)

        operation.completionBlock = {
            DispatchQueue.main.async {
                self.smallImageView.image = operation.outputImage
            }
        }

        queue.addOperation(operation)
    }

}
