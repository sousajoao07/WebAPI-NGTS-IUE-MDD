//
//  LampsViewController.swift
//  Login
//
//  Created by João Sousa on 22/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit
import LDSwiftEventSource

class LampsViewController: UITableViewController, EventHandler {
    
    struct LampData: Decodable{
        let data: [Lamp]
    }
    
    var arrayLamps = [Lamp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializing the refreshControl
        tableView.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshAfterPush(_:)), for: .valueChanged)
        self.tableView.refreshControl?.beginRefreshing()
        
        let url = URL.init(string: Constants.Api.SYNC)!
        let config = EventSource.Config.init(handler: self, url: url)
        let eventSource = EventSource.init(config: config)
        eventSource.start()
        
        
        configureItems()
    }
    
    @objc func refreshAfterPush(_ sender: AnyObject) {
        // Code to refresh table view
        getLamps()
    }
    
    func refreshTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
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
    
    
    @objc private func getLamps(){
        print("Perform get lamps")
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
            
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
                            print("Get lamps with success!")
                            
                            let lamps = self.parseResponseData(data: data)
                            
                            self.updateArrayLamps(lamps: lamps)
                            self.refreshTableView()
                        }
                    
                    }.resume() //never forget this resume
            }
        }
    }
    
    @objc fileprivate func changeStateById(id: String){

        guard let url = URL(string: Constants.Api.URL + "/lamp/" + id + "/toggle" ) else {return}
        var request = URLRequest(url:  url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        do{
            let params = ["id" : id]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                if let err = err {
                    print ("Failed to change state:", err)
                    return
                } else if
                    let resp = resp as? HTTPURLResponse,
                    resp.statusCode == 200 {
                        self.getLamps()
                } else {
                    print("The lamp state was not changed")
                }
                
                }.resume() //never forget this resume
        }catch{
            print("Error:", error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLamps.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier",
                                                 for: indexPath) as! LampCell
        
        let lamp = arrayLamps[indexPath.row]
        cell.selectionStyle = .none
        cell.labelName?.text = lamp.name
        cell.labelIp?.text = lamp.ip
        cell.labelState?.text = lamp.state == true ? "On" : "Off"
        cell.button.isOn = lamp.state
        cell.button.tag = indexPath.row
        cell.button.tintColor = .orange
        
        cell.button.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150 //or whatever you need
    }
    
    @objc func switchChanged(_ sender: UISwitch!){
        print(sender.tag)
        let id = arrayLamps[sender.tag].id
        let stringId = String(id)
        
        changeStateById(id: stringId)
        refreshTableView()
    }
    
    func onOpened() {
        print("Opened server event")
    }
    
    func onClosed() {
        print("Opened server event")
    }
    
    func onMessage(eventType: String, messageEvent: MessageEvent) {
        print("On message server event")
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()

            let lamps = self.parseResponseString(string: messageEvent.data)
            
            self.updateArrayLamps(lamps: lamps)
            self.refreshTableView()
        }
    }
    
    
    func stringToData(string: String) -> Data {
        return string.data(using: .utf8)!
    }
    
    func parseResponseString(string: String) -> [Lamp] {
        return self.parseResponseData(data: self.stringToData(string: string))
    }
    
    func parseResponseData(data: Data) -> [Lamp] {
        var lamps = [Lamp]()
        
        do {
            lamps = try JSONDecoder().decode([Lamp].self, from: data)
        } catch {
            print("Error parsing api data to lamps array")
        }
        
        return lamps
    }
    
    func updateArrayLamps(lamps: [Lamp]) {
        for lamp in lamps {
            if let i = self.arrayLamps.firstIndex(where: { $0.id == lamp.id }) {
                self.arrayLamps[i] = lamp
            } else {
                self.arrayLamps.append(lamp)
            }
        }
    }

    func onComment(comment: String) {
        print("On comment server event")
    }
    
    func onError(error: Error) {
        print("On error server event")
    }
}
