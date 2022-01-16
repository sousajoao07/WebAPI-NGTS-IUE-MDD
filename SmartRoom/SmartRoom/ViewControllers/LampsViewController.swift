//
//  LampsViewController.swift
//  Login
//
//  Created by João Sousa on 22/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class LampsViewController: UITableViewController{
    
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
        
        tableView.refreshControl?.beginRefreshing()

        refreshTableView()
    }
    
    
    @objc func refreshAfterPush(_ sender: AnyObject) {
        // Code to refresh table view
        getLamps()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func refreshTableView(){
        getLamps()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    private func getLamps(){
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
                        let response = try JSONDecoder().decode([Lamp].self, from: data)
                        self.arrayLamps = response
                        print(self.arrayLamps.count)
                        
                    } catch let parseError as NSError {
                        print("Error")
                        print(parseError.localizedDescription)
                    }
                }
                
                }.resume() //never forget this resume
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
        cell.button.onTintColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
        
}
