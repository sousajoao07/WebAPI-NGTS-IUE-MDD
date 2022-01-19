//
//  HomeController.swift
//  SmartRoom
//
//  Created by João Sousa on 16/01/22.
//  Copyright © 2022 João Sousa. All rights reserved.
//

import UIKit

class RoomViewController: UITableViewController{
    
    var arrayLamps = [Lamp]()
    var arrayRooms = [Room]()
    var roomState: Bool? = false
    var bulbNumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializing the refreshControl
        tableView.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshAfterPush(_:)), for: .valueChanged)
        
        getRooms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRooms()
    }
    
    @objc func refreshAfterPush(_ sender: AnyObject) {
        self.getRooms()
    }

    func refreshTableView(){
        getRooms()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    

    private func getRooms(){
        print("Perform get rooms")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/rooms" ) else {return}
        var request = URLRequest(url:  url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "GET"
        do{
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                if let err = err {
                    print ("Failed to get rooms:", err)
                    return
                } else if
                    let data = data,
                    let resp = resp as? HTTPURLResponse,
                    resp.statusCode == 200 {
                    do {
                        print("Get rooms with success!")
                        let response = try JSONDecoder().decode([Room].self, from: data)
                        self.arrayRooms = response

                        DispatchQueue.main.async {
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
    
    private func changeRoomState(id: Int){
        print("Perform Change Room State")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/lamp/toggleRoom/" + String(id)) else {return}
        var request = URLRequest(url:  url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                print ("Failed to toggle room:", err)
                return
            } else if
                let resp = resp as? HTTPURLResponse,
                resp.statusCode == 200 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //self.getLamps()
                }
            } else {
                print("The toogle went wrong")
            }
            
            }.resume() //never forget this resume
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRooms.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell",
                                                 for: indexPath) as! RoomCell
        
        let room = arrayRooms[indexPath.row]
        cell.selectionStyle = .none
        //cell.labelState?.text = lamp.state == true ? "On" : "Off"
        cell.labelState.text = room.state == true ? "On" : "Off"
        cell.button.isOn = room.state
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
        let id = arrayRooms[sender.tag].id
        self.changeRoomState(id: id)
        self.refreshTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
