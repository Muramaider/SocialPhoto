//
//  AuthentificationViewController.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 12/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class AuthentificationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfTokenExist()
        setupUI()
        [loginTextField, passwordTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @IBAction func singinButtonTapped(_ sender: Any) {
        userAuthorization()
    }
    
    private func setupUI() {
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        loginTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        signinButton.isEnabled = false
        signinButton.alpha = 0.3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideTextField(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            if signinButton.isEnabled == true {
                userAuthorization()
            } else {
                Alert.instance.authorizationEmptyFields()
            }
        }
        return true
    }

    @objc func tapOutsideTextField(gesture: UITapGestureRecognizer) {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //Change rootViewController to TabBar
    private func switchView() {
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let tabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    @objc private func editingChanged(_ textField: UITextField) {
        
        guard let login = loginTextField.text, !login.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signinButton.isEnabled = false
            signinButton.alpha = 0.3
            
            return
        }
        signinButton.isEnabled = true
        signinButton.alpha = 1.0
        
    }
    
    
    private func checkIfTokenExist() {
        
        guard KeyChain.instance.readToken() != nil else {
            print("NO TOKEN")
            return
        }
        
        print("TOKEN EXIST")
        Loader.instance.addShadowView()
        ServiceManager.shared.checkToken { result in
            
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    self.switchView()
                }
            case .fail(let error):
                guard error == "Unauthorized" else {
                    //Go to offline mode
                    DispatchQueue.main.async {
                        Loader.instance.removeShadowView()
                        
                        //Bad realization. mb can do better one.
//                        Loader.instance.connection = .offline
                        ServiceManager.shared.isOnline = false
                        //
                        self.switchView()
                    }
                    return
                }
                
                _ = KeyChain.instance.deleteToken()
                print("TOKEN DELETED")
//                coredata delete
                CoreDataWorker.instance.deleteAllData()
                DispatchQueue.main.async {
                    Loader.instance.removeShadowView()
                    Alert.instance.showAlert(title: error)
                }
            }
        }
        
    }

    private func userAuthorization() {
        
        guard let login = loginTextField.text, let pass = passwordTextField.text else { return }
        let parameters = ["login": login, "password": pass]
        
        ServiceManager.shared.signIn(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let token):
                _ = KeyChain.instance.saveToken(token: token)
                DispatchQueue.main.async {
                    self?.switchView()
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    Alert.instance.showAlert(title: error)
                }
            }
            
        }
    
    }
    
}

