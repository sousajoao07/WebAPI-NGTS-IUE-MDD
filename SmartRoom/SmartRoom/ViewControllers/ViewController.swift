//
//  ViewController.swift
//  Login
//
//  Created by João Sousa on 05/11/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?
    ) {
        
        //navigationItem.title = usernameTextField.text
    }

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginPage", sender: loginButton)
    }
    @IBAction func SignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterPage", sender: signupButton)
    }
    
    
}

