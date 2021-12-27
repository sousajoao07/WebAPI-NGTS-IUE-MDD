//
//  LoginViewController.swift
//  SmartRoom
//
//  Created by João Sousa on 24/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?
    //    ) {
    //    //navigationItem.title = usernameTextField.text
    //    segue.destination.navigationItem.title = "Login"
    //}
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func LoginUser(_ sender: UIButton) {
        performSegue(withIdentifier: "TabBar", sender: loginButton)
    }
    
}
