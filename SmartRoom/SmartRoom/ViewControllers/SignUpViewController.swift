//
//  SignUpViewController.swift
//  SmartRoom
//
//  Created by João Sousa on 26/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Register"
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPasswordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        //validade fields
        let error  = validateFields()
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showError(error!)
        }
        else{
            //Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let confirmPassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create user
            createUser(username: username, email: email, password: password, confirmPassword: confirmPassword)
            
            //Transition to home screen
            transitionToHomeNavigationController()
        }
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //check the fields and validade that d+the dadta is correct. if everything is correct, this method return nil, Otherwise, it returns the error message
    func validateFields() -> String? {
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        // Check if password is secure
        //let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //if Utilities.isPasswordValid(cleanedPassword) == false {
        //    //Password is not secure enough
        //    return "Please make sure your password is at least 8 characters, contains a special character and a number"
        //}
        
        return nil
        
    }
    
    @objc fileprivate func createUser(username: String, email: String, password: String, confirmPassword: String){
        
        print("Create user")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/register" ) else {return}
        var signUpRequest = URLRequest(url:  url)
        signUpRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        signUpRequest.httpMethod = "POST"
        do{
            let params = ["name": username,"email": email, "password": password, "password_confirmation": confirmPassword]
            
            signUpRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            URLSession.shared.dataTask(with: signUpRequest) { (data, resp, err) in
                if err != nil {
                    print ("Failed to create the user")
                    return
                }
                
                print("User created with success!")
                //self.fetchPosts()
                }.resume() //never forget this resume
        }catch{
            print("Failed to serialise data:", error)
        }
    }
    
    func transitionToHomeNavigationController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lampsViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.lampsViewController)

        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(lampsViewController)
    }
}
