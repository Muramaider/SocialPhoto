//
//  PostNewPostViewController.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 01/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class PostNewPostViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var newImagePost: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newImagePost.image = image
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareBarButtonPressed))

    }
    // MARK: - Features required:
    // addObserver for new post
    @objc func shareBarButtonPressed() {
        
        guard let imageString = newImagePost.image?.toString() else { return }
        
        guard let description = descriptionTextField.text else { return }
        let parameters = ["image": imageString, "description": description]
        
        Loader.instance.addShadowView()
        ServiceManager.shared.postNewPost(parameters: parameters) { result in
            switch result {
                
            case .success(_):
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popToRootViewController(animated: false)
                    NotificationCenter.default.post(name: .newPostWasPosted, object: nil)
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    Alert.instance.showAlert(title: error)
                }
            }
        }
    }
    
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.jpegData(compressionQuality: 0.0)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
extension NSNotification.Name {
    static let newPostWasPosted = NSNotification.Name(rawValue: "newPostWasPosted")
}
