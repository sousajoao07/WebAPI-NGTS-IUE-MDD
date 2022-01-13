//
//  ProfileViewController.swift
//  SmartRoom
//
//  Created by João Sousa on 12/01/22.
//  Copyright © 2022 João Sousa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        let username = self.readUser()
        self.usernameLabel?.text = username
    }
    
    func setUpElements(){
        Utilities.styleFilledButton(logoutButton)
    }
    
    func readUser()->String?{
        do{
            let dataUser = try KeychainInterface.read(service: "email", account: "laravelApi")
            let user = String(data: dataUser, encoding: .utf8)!
            print(user)
            return user
        } catch {
            print("User is null")
            return nil
        }
    }
    
    
    @IBAction private func loginTapped(_ sender: UIButton) {
        
        print("Logout tapped")
        self.cleanCredentials()
        self.transitionToHomeNavigationController()
    }
    
    private func cleanCredentials(){
        do{
            try KeychainInterface.delete(service: "email", account: "laravelApi")
            try KeychainInterface.delete(service: "access-token", account: "laravelApi")
            try KeychainInterface.delete(service: "password", account: "laravelApi")
            
        } catch {
            print("Error delete the data on Keychain")
        }
        print("User logged out")
    }
    
    private func transitionToHomeNavigationController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
    }
}
