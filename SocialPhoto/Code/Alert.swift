//
//  Alert.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 31/08/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    static let instance = Alert()
    
//  Срабатывает если не все поля в при авторизации заполнены
    func authorizationEmptyFields() {
        let alert = UIAlertController(title: "Empty fields!",
                                      message: "Fill in all the input fields",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if let VC = UIApplication.shared.delegate?.window??.rootViewController {
            VC.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title,
                                      message: "Try again",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if let VC = UIApplication.shared.delegate?.window??.rootViewController {
            VC.present(alert, animated: true, completion: nil)
        }
    }
}
