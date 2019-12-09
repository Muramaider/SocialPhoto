//
//  PhotoSelectorViewController.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 01/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class PhotoSelectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImages = createPhotoArray()
        collectionView.dataSource = self
        collectionView.delegate = self
       
    }
    
}

extension PhotoSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSelectionCell", for: indexPath) as! PhotoSelectionCollectionViewCell
        
        cell.setPhoto(with: photoImages[indexPath.item])
        
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let filterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        
        filterVC.image = photoImages[indexPath.row]
        
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
}

extension PhotoSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumn: CGFloat = 3
        let width = collectionView.frame.size.width
        
        
        return CGSize(width: (width/numberOfColumn), height: (width/numberOfColumn))
    }
    
}

extension PhotoSelectionViewController {
    
    private func createPhotoArray() -> [UIImage] {
      
        var photo: [UIImage] = []
        
        if
        let photo1 = UIImage(named: "new1"),
        let photo2 = UIImage(named: "new2"),
        let photo3 = UIImage(named: "new3"),
        let photo4 = UIImage(named: "new4"),
        let photo5 = UIImage(named: "new5"),
        let photo6 = UIImage(named: "new6"),
        let photo7 = UIImage(named: "new7"),
        let photo8 = UIImage(named: "new8") {
          
            photo.append(photo1)
            photo.append(photo2)
            photo.append(photo3)
            photo.append(photo4)
            photo.append(photo5)
            photo.append(photo6)
            photo.append(photo7)
            photo.append(photo8)
        }
        return photo
    }
    
}
