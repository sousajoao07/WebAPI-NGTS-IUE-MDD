//
//  ViewController.swift
//  Login
//
//  Created by João Sousa on 05/11/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginPage", sender: loginButton)
    }
    @IBAction func SignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterPage", sender: signupButton)
    }

    //override func viewDidAppear(_ animated: Bool) {
    //    let email = readUser()
    //    if(email == nil)
    //    {
    //        setUpElements()
    //    }else{
    //        transitionToHomeTBC()
    //    }
    //}
    
    override func viewDidLoad() {
       super.viewDidLoad()
      setUpElements()
    }
    
    func setUpElements(){
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signupButton)
    }
    
    func transitionToHomeTBC(){
        let lampsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.lampsViewController) as? UITabBarController
        
        view.window?.rootViewController = lampsViewController
        view.window?.makeKeyAndVisible()
    }
}

