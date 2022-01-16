//
//  HomeController.swift
//  SmartRoom
//
//  Created by João Sousa on 16/01/22.
//  Copyright © 2022 João Sousa. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController{
    
    var arrayLamps = [Lamp]()
    var roomState: Bool? = false
    var bulbNumber: Int = 0
    
    @IBOutlet weak var switchState: UISwitch!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var bulbNumberLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getLamps()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    private func setupElements(){
        
        switchState.onTintColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)

    }
    
    func updateElements(){
        DispatchQueue.main.async {
            self.bulbNumberLabel.text = "Room Lamps: " + String(self.bulbNumber)
            self.stateLabel?.text = self.roomState == true ? "On" : "Off"
            self.switchState.isOn = self.roomState == nil ? false : true
        }
    }
    
    
    @IBAction func switchStateTapped(_ sender: Any) {
        self.changeRoomState()
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
                        self.bulbNumber = self.arrayLamps.count
                        
                        self.roomState = nil
                        for lamp in self.arrayLamps{
                            if lamp.state == true{
                                self.roomState = true
                            }
                        }
                        
                        self.updateElements()
                        
                    } catch let parseError as NSError {
                        print("Error")
                        print(parseError.localizedDescription)
                    }
                }
                
                }.resume() //never forget this resume
        }
    }
    
    private func changeRoomState(){
        print("Perform Change Room State")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/lamp/toggleAll") else {return}
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
                    self.getLamps()
                }
                
                
            } else {
                print("The toogle went wrong")
            }
            
            }.resume() //never forget this resume
       
    }
   
}
