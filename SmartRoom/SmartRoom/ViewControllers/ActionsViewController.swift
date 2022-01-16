//
//  ActionsViewController.swift
//  SmartRoom
//
//  Created by João Sousa on 14/01/22.
//  Copyright © 2022 João Sousa. All rights reserved.
//

import UIKit

class ActionsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var gestureLabel: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var ArrayOfActions = ["Turn On", "Turn Off", "Increase Light", "Decrease Light", "Next Color", "Previous Color", "Disco Flow"]
    
    var pickerData: [String] = [String]()
    var itemAtDefaultName: String = String.init()
    var gestureId: Int?
    var gestureName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input the data into the array
        pickerData = ArrayOfActions
        setDefaultValue(item: itemAtDefaultName, inComponent: 0)
        setUpElements()
    }
    
    private func setUpElements(){
        gestureLabel.text = "Change action for '" + gestureName! + "' gesture"
        Utilities.styleFilledButton(saveButton)
    }
    
    private func saveGestureAction(id: Int, action: String){
        print("Perform Save Gesture")
        
        //fire off a login request to server of localhost
        guard let url = URL(string: Constants.Api.URL + "/gesture/" + String(id) + "/action" ) else {return}
        var request = URLRequest(url:  url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "PATCH"
        do{
            let params = ["action": action]
            print(id)
            print(params)
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                if let err = err {
                    print ("Failed to change action:", err)
                    return
                } else if
                    let resp = resp as? HTTPURLResponse,
                    resp.statusCode == 200 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else {
                    print("The action was not changed")
                }
                
                }.resume() //never forget this resume
        }catch{
            print("Error:", error)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let action = prepareActionToJson(actionEnum: getSelectedPickerValue())
        let id = gestureId
        saveGestureAction(id: id!, action: action)
        
    }
    
    func prepareActionToJson(actionEnum: String)->String{
        var actionString = String.init()
        switch actionEnum{
        case "Turn On": actionString = "turn_on"
        case "Turn Off" : actionString = "turn_off"
        case "Increase Light" : actionString = "increase_light"
        case "Decrease Light" : actionString = "decrease_light"
        case "Next Color": actionString = "next_color"
        case "Previous Color" : actionString = "previous_color"
        case "Disco Flow" : actionString = "disco_flow"
        default:
            actionString = String.init()
        }
        return actionString
    }
    
    private func getSelectedPickerValue()->String{
        let component = 0
        let row = picker.selectedRow(inComponent: component)
        let action = picker.delegate?.pickerView?(picker, titleForRow: row, forComponent: component)
        
        return action!
    }
    private func setDefaultValue(item: String, inComponent: Int){
        if let indexPosition = pickerData.firstIndex(of: item){
            picker.selectRow(indexPosition, inComponent: inComponent, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }

}
