//
//  FilterViewController.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 01/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let filterProvider = FilterProvider.init()
    let context = CIContext()
    
    var image: UIImage?
    var thumbNail: UIImage?
    var cachedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupFlowLayout()
        
        mainImageView.image = image
        thumbNail = createThumbnail()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonPressed))
        
    }

}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterProvider.filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCollectionViewCell
        cell.setFilterToCell(with: thumbNail, filterName: filterProvider.filterArray[indexPath.item])

        return cell
    }
    
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120.0,
                      height: collectionView.bounds.height - 16.0 * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Loader.instance.addShadowView()
        let queue = OperationQueue()
        let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell
        
        if cachedImage == nil {
            cachedImage = mainImageView.image
        }
        
        guard let chosenFilter = cell?.filterNameLabel.text else { return }
        let operation = FilterImageOperation(inputImage: cachedImage, chosenFilter: chosenFilter)
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                self.mainImageView.image = operation.outputImage
                Loader.instance.removeShadowView()
            }
        }
        
        queue.addOperation(operation)
    }
    
}

extension FilterViewController {
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
    }

    private func createThumbnail() -> UIImage {
        var thumbnail = UIImage()
        
        if  let image = image {
            let imageData = image.jpegData(compressionQuality: 0.5)
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 200] as CFDictionary
        
            let source = CGImageSourceCreateWithData(imageData! as CFData, nil)!
            let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
            thumbnail = UIImage(cgImage: imageReference)
        }
        
        return thumbnail
        
    }
    
    @objc func nextButtonPressed() {
        
        let postNewPost = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostNewPostViewController") as! PostNewPostViewController
        postNewPost.image = mainImageView.image
        
        self.navigationController?.pushViewController(postNewPost, animated: true)
    }
    
}
