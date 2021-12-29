//
//  LoginViewController.swift
//  SmartRoom
//
//  Created by João Sousa on 24/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func LoginUser(_ sender: UIButton) {
        performSegue(withIdentifier: "TabBar", sender: loginButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Login"
        setUpElements()
    }
    
    func setUpElements(){
        //Hyde error label
        errorLabel.alpha = 0
        
        //Style elements
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(passTextField)
        Utilities.styleFilledButton(loginButton)
        
       
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        //validade fields
        let error  = validateFields()
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showError(error!)
        }
        else{
            //Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Login user
             handleLogin(email: username, password: password)
            
            //Transition to home screen
            transitionToHome()
            
        }
    }
            
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  passTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        return nil
        
    }
@objc fileprivate func handleLogin(email: String, password: String){
        print("Perform login and refetch posts")
    
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/login" ) else {return}
        var loginRequest = URLRequest(url:  url)
        loginRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        loginRequest.httpMethod = "POST"
        do{
            let params = ["email": email,"password": password]
            
            loginRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            URLSession.shared.dataTask(with: loginRequest) { (data, resp, err) in
                if let err = err {
                    print ("Failed to login:", err)
                    return
                }
                
                print("Logged in with success!")
                //self.fetchPosts()
            }.resume() //never forget this resume
        }catch{
            print("Failed to serialise data:", error)
        }
        
    }
    
    func transitionToHome(){
        let lampsViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.lampsViewController) as? LampsViewController
        
        view.window?.rootViewController = lampsViewController
        view.window?.makeKeyAndVisible() 
    }
    
    
}
