//
//  AddEditViewController.swift
//  GeoServicesApp
//
//  Created by sambuddha nath on 3/19/21.
//

import UIKit

protocol AddEditPlaceDelegate {
    func addPlace(placeDescription: PlaceDescription)
}

class AddEditViewController: UIViewController, UITextFieldDelegate {
    
    var placeDescriptionDelegate: AddEditPlaceDelegate?
    
    var placeDescription: PlaceDescription? = nil
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addressTitleField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var elevationField: UITextField!
    @IBOutlet weak var LatitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Add Edit View Loaded")
        
        nameField.delegate = self
        descriptionField.delegate = self
        categoryField.delegate = self
        addressTitleField.delegate = self
        
        defaultData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
    @objc func defaultData() {
        if placeDescription == nil {
            // Adding new Place
            self.title = "Enter New Place Details"
            return
        }
        
        self.title = "Edit Place Details"
        let parameters = [
            "jsonrpc": 2.0,
            "method": "get",
            "params": [placeDescription?.name],
            "id": 3
        ] as [String : Any]
        let url = "http://localhost:8080"
        
        nameField.text = placeDescription?.name
        nameField.isUserInteractionEnabled = false
        nameField.borderStyle = .none
        nameField.textColor = UIColor.gray
        jsonRPCGetPlaceDescription(parameters: parameters, urlString: url)
    }
    
    @objc func handleDone() {
        let pD = PlaceDescription()
        pD.name = placeDescription?.name ?? "**Name**"
        pD.description = descriptionField.text ?? "Error"
        pD.category = categoryField.text ?? "Error"
        pD.addressTitle = addressTitleField.text ?? "Error"
        pD.elevation = Double((elevationField.text ?? "0") as String) ?? 0
        pD.latitude = Double((LatitudeField.text ?? "0") as String) ?? 0
        pD.longitude = Double((longitudeField.text ?? "0") as String) ?? 0
        
        placeDescriptionDelegate?.addPlace(placeDescription: pD)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func jsonRPCGetPlaceDescription(parameters:[String:Any], urlString:String) {
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid

        //create the url with URL
        let url = URL(string: urlString)! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    var jsonData = [String:AnyObject]()
                    let temp: AnyObject
                    temp = json as AnyObject
                    let utils = Utils()
                    let convertedString = utils.jsonToString(json: temp)
                    jsonData = utils.convertStringToDictionary(text: convertedString)
                    var result = [String:AnyObject]()
                    result = jsonData["result"] as! [String : AnyObject]
                    print(result)
                    DispatchQueue.main.async {
                        
                        if self.placeDescription?.description == nil {
                            self.placeDescription?.description = result["description"] as? String
                        }
                        self.descriptionField.text = self.placeDescription?.description
                        
                        if self.placeDescription?.category == nil {
                            self.placeDescription?.category = result["category"] as? String
                        }
                        self.categoryField.text = self.placeDescription?.category
        
                        if self.placeDescription?.addressTitle == nil {
                            self.placeDescription?.addressTitle = result["address-title"] as? String
                        }
                        self.addressTitleField.text = self.placeDescription?.addressTitle
                        
                        if self.placeDescription?.elevation == 0 {
                            self.placeDescription?.elevation = result["elevation"] as? Double ?? 0
                        }
                        self.elevationField.text = String(self.placeDescription?.elevation ?? 0)
                        
                        if self.placeDescription?.latitude == 0 {
                            self.placeDescription?.latitude = result["latitude"] as? Double ?? 0
                        }
                        self.LatitudeField.text = String(self.placeDescription?.latitude ?? 0)
                        
                        if self.placeDescription?.longitude == 0 {
                            self.placeDescription?.longitude = result["longitude"] as? Double ?? 0
                        }
                        self.longitudeField.text = String(self.placeDescription?.longitude ?? 0)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
