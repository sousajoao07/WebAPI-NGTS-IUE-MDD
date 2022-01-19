//
//  ActionsViewController.swift
//  Login
//
//  Created by João Sousa on 22/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit

class GesturesViewController: UITableViewController{
    
    var gestures = [Gesture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializing the refreshControl
        tableView.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshAfterPush(_:)), for: .valueChanged)
        
        getGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGestures()
    }
    
    
    func getGestures(){
        self.tableView.refreshControl?.beginRefreshing()
        print("Perform Get Gestures")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/gestures" ) else {return}
        var request = URLRequest(url:  url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "GET"
        do{
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                if let err = err {
                    print ("Failed to get Gestures:", err)
                    return
                } else if
                    let data = data,
                    let resp = resp as? HTTPURLResponse,
                    resp.statusCode == 200 {
                    do {
                        print("Get gestures with success!")
                        let response = try JSONDecoder().decode([Gesture].self, from: data)
                        self.gestures = response
                        print(response)
                        DispatchQueue.main.async(){
                            self.tableView.reloadData()
                            self.tableView.refreshControl?.endRefreshing()
                        }
                        
                    } catch let parseError as NSError {
                        print("Error parse gestures from api")
                        print(parseError.localizedDescription)
                    }
                }
                else{
                    print("Error making request")
                }
                
                }.resume() //never forget this resume
        }
    }
    
    
    @objc func refreshAfterPush(_ sender: AnyObject) {
        self.getGestures()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gestures.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdCellGesture",
                                                 for: indexPath) as! GestureCell
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        cell.selectedBackgroundView = view
        
        let gesture = gestures[indexPath.row]
        
        cell.labelAction.text = parseEnumToString(actionEnum: gesture.action!)
        cell.labelGesture.text = gesture.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = tableView.indexPathForSelectedRow {
            guard let destinationVC = segue.destination as? ActionsViewController else {return}
            let selectedRow = indexPath.row
            destinationVC.gestureId = gestures[selectedRow].id
            destinationVC.gestureName = gestures[selectedRow].name
            destinationVC.itemAtDefaultName = parseEnumToString(actionEnum: gestures[selectedRow].action!)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueToActions", sender: indexPath.row)
        
    }
    
    func parseEnumToString(actionEnum: Action)->String{
        var actionString = String.init()
        switch actionEnum{
        case .turn_on: actionString = "Turn On"
        case .turn_off: actionString = "Turn Off"
        case .increase_light: actionString = "Increase Light"
        case .decrease_ligh: actionString = "Decrease Light"
        case .next_color: actionString = "Next Color"
        case .previous_color: actionString = "Previous Color"
        case .disco_flow: actionString = "Disco Flow"
        case .unknown(_):
            actionString = ""
        }
        return actionString
    }
    
}
