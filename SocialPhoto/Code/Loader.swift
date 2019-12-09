//
//  Loader.swift
//  Course2FinalTask
//
//  Created by Vinogradov Alexey on 27/08/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

//enum IsConnected {
//    case online
//    case offline
//}

final class Loader: UIView {
    
    static let instance = Loader()
    
    private init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    //Bad realization. mb can do better one.
//    var connection: IsConnected?
//
    lazy var shadowView: UIView = {
        let shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        shadowView.isUserInteractionEnabled = true
    
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.center = shadowView.center
        indicator.startAnimating()
        indicator.isUserInteractionEnabled = true
        
        shadowView.addSubview(indicator)
    
        return shadowView
    }()
    
    func addShadowView() {
        guard shadowView.superview == nil else {
            return
        }
        self.addSubview(shadowView)
        UIApplication.shared.keyWindow?.addSubview(shadowView)
    }
    
    func removeShadowView() {
        guard shadowView.superview != nil else {
            return
        }
        self.shadowView.removeFromSuperview()
    }
    
}
