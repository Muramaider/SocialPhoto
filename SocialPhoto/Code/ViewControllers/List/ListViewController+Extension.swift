//
//  ListViewController+Extension.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 25/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell" ) as! ListTableViewCell
        cell.updateList(testUsers[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileViewController.userId = testUsers[indexPath.row].id
            self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }
    
}
