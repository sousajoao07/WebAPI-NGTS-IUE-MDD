//
//  LoginViewController.swift
//  SmartRoom
//
//  Created by João Sousa on 24/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    struct LoginData: Decodable{
        let token: String
        let token_type: String
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
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
            
        }
    }
            
    func showError(_ message:String){
        DispatchQueue.main.async {
            self.errorLabel.text = message
            self.errorLabel.alpha = 1
        }
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  passTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    @objc fileprivate func handleLogin(email: String, password: String){
        print("Perform login")
    
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
                } else if
                    let data = data,
                    let resp = resp as? HTTPURLResponse,
                    resp.statusCode == 201 {
                    do {
                        print("Logged in with success!")
                        let loginData = try JSONDecoder().decode(LoginData.self, from: data)
                        print(loginData.token)
                        //guardar as credenciais
                        DispatchQueue.main.async {
                            print("Token", loginData.token)
                            print("User", email)
                            print("Password", password)
                            
                            self.saveAccessToken(token: loginData.token)
                            self.savePassword(password: password)
                            self.saveEmail(email: email)
                        
                            //enviar para a lista com as lampadas, tab controller view
                            self.transitionToHomeNavigationController()
                        }
                    } catch let parseError as NSError {
                        print("Error")
                        print(parseError.localizedDescription)
                    }
                } else {
                    print("Not logged in")
                    self.showError("Error in Credentials")
                }
                
            }.resume() //never forget this resume
        }catch{
            print("Failed to serialise data:", error)
        }
    }
    
    
    func transitionToHomeNavigationController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        //self.present(mainTabBarController, animated:true, completion:nil)
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    func saveAccessToken(token: String){
        let _token = token
        let data = Data(_token.utf8)
        do {
            try KeychainInterface.save(data: data, service: "access-token", account: "laravelApi")
        } catch {
            print("Error saving the token on Keychain")
        }
    }
    
    func savePassword(password: String){
        let _password = password
        let data = Data(_password.utf8)
        do {
            try KeychainInterface.save(data: data, service: "password", account: "laravelApi")
        } catch {
            print("Error saving the password on Keychain")
        }
    }
    
    func saveEmail(email: String){
        let _email = email
        let data = Data(_email.utf8)
        do {
            try KeychainInterface.save(data: data, service: "email", account: "laravelApi")
        } catch {
            print("Error saving the email on Keychain")
        }
    }

}
