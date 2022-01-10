//
//  LampsViewController.swift
//  Login
//
//  Created by João Sousa on 22/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class LampsViewController: UITableViewController{
    
    
    class LampCell: UITableViewCell{
        @IBOutlet var name : UILabel?
        @IBOutlet var state : UILabel?
        @IBOutlet var ip : UILabel?
        @IBOutlet var btnSwitch : UISwitch?
    }
    
    struct LampData: Decodable{
        let data: [Lamp]
    }
    
    var arrayLamps = [Lamp]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureItems()
        getLamps()
        

        
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
            try KeychainInterface.delete(service: "access-token", account: "laravelApi")
            try KeychainInterface.delete(service: "password", account: "laravelApi")
            
        } catch {
            print("Error delete the data on Keychain")
        }
        print("User logged out")
    }
    
    func transitionToHomeNavigationController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")

        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
    }
    
    func readToken()->String?{
        do{
            let dataToken = try KeychainInterface.read(service: "access-token", account: "laravelApi")
            let token = String(data: dataToken, encoding: .utf8)!
            print(token)
            return token
        } catch {
            print("Token is null")
            return nil
        }
    }
    
    
    func getLamps(){
        print("Perform get lamps")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/lamps" ) else {return}
        var request = URLRequest(url:  url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "GET"
        do{
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                if let err = err {
                    print ("Failed to get Lamps:", err)
                    return
                } else if
                    let data = data,
                    let resp = resp as? HTTPURLResponse,
                    resp.statusCode == 200 {
                    do {
                        print("Get lamps with success!")
                        let response = try JSONDecoder().decode(LampData.self, from: data)
                        self.arrayLamps = response.data
                        print(self.arrayLamps.count)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    } catch let parseError as NSError {
                        print("Error")
                        print(parseError.localizedDescription)
                    }
                }
                
                }.resume() //never forget this resume
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLamps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! LampCell
        let lamp = arrayLamps[indexPath.row]
        
        cell.name?.text = lamp.name
        
        //let labelName = cell.textLabel
        //let labelIp = cell.textLabel
        //labelName?.text = lamp.name
        //labelName?.center = CGPoint(x: 160, y: 285)
        //labelName?.frame = CGRect(x: 0, y: 0, width: 50, height: 21)
        //labelName?.textAlignment = .center
    
        
        //cell.imageView?.image = UIImage(named: "light")
        

 
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150 //or whatever you need
    }
}
