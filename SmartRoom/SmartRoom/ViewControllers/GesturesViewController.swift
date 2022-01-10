//
//  ActionsViewController.swift
//  Login
//
//  Created by João Sousa on 22/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class GesturesViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .done,
            target: self,
            action: #selector(didTapButton(sender:))
        )
        
    }
    
    @objc func didTapButton(sender: UIBarButtonItem){
        print("Logout tapped")
        self.cleanCredentials()
        self.transitionToHomeNavigationController()
    }
    
    func cleanCredentials(){
        do{
            try KeychainInterface.delete(service: "email", account: "laravelApi")
            try KeychainInterface.delete(service: "user", account: "laravelApi")
            try KeychainInterface.delete(service: "password", account: "laravelApi")
            
        } catch {
            print("Error delete the data on Keychain")
        }
        print("User logged out")
    }
    
    func transitionToHomeNavigationController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        //self.present(loginNavController, animated:true, completion:nil)
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
    }
    
}
