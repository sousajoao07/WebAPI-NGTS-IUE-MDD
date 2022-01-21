//
//  LampRoomViewController.swift
//  SmartRoom
//
//  Created by João Sousa on 20/01/2022.
//

import UIKit

class LampRoomViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].name
    }
   
    
    var pickerData: [Room] = [Room]()
    var roomId: Int?
    var lampId: Int?
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRooms()
        //setDefaultValue(item: itemAtDefaultName, inComponent: 0)
        setUpElements()
        
    }
    
    private func setUpElements(){
        Utilities.styleFilledButton(saveButton)
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
                        DispatchQueue.main.async {
                            self.pickerData = response
                            self.picker.reloadAllComponents()
                        }
                        
                    } catch let parseError as NSError {
                        print("Error")
                        print(parseError.localizedDescription)
                    }
                    
                }
                
                }.resume() //never forget this resume
        }
        
    }
    
    private func saveGestureAction(id: Int, roomId: Int){
        print("Perform Save Gesture")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/lamp/" + String(id) + "/room" + String(roomId)) else {return}
        var request = URLRequest(url:  url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        do{
            
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                if let err = err {
                    print ("Failed to change action:", err)
                    return
                } else if
                    let resp = resp as? HTTPURLResponse,
                    resp.statusCode == 200 {
                    DispatchQueue.main.async() {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else {
                    print("The action was not changed")
                }
                
                }.resume() //never forget this resume
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let _roomId = roomId
        let id = lampId
        saveGestureAction(id: id!, roomId: _roomId!)
        
    }
    
 
}
