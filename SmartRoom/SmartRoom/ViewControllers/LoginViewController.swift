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
            
            //User success Login so -> Transition to home screen
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
                        
                        print(loginData.token_type)
                        
                        //guardar as credenciais
                        
                        //enviar para a lista com as lampadas, tab controller view

                    } catch let parseError as NSError {
                        print("Error")
                        print(parseError.localizedDescription)
                    }
                } else {
                    print("Not logged in")
                }
                
            }.resume() //never forget this resume
        }catch{
            print("Failed to serialise data:", error)
        }
    }
    
    func transitionToHome(){
        let lampsViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.lampsViewController) as? UITabBarController
        
        view.window?.rootViewController = lampsViewController
        view.window?.makeKeyAndVisible()
    }
    
    func saveAccessToken(token: String){
        let accessToken = token
        let data = Data(accessToken.utf8)
        do {
            try KeychainInterface.save(data: data, service: "access-token", account: "laravelApi")
        } catch {
            print("Error saving the token on Keychain")
        }
    }
    
    func savePassword(string: String){
    }
}
