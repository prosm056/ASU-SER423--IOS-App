//
//  PlacesTableViewController.swift
//  GeoServicesApp
//
//  Created by sambuddha nath on 3/19/21.
//

import UIKit

struct ResultItem: Codable {
    let name: String
    let description: String
    let category: String
    init() {
        name = "Name"
        description = "description"
        category = "category"
    }
}

struct Result: Codable {
    var data = [ResultItem]()
}

struct ResultJsonRPC: Codable {
    let jsonrpc: String
    let id:Int
    let result:[String]
}

let reuseIdentifier = "cell"

class PlacesTableViewController: UITableViewController {
    
    public var placeDescriptionList = [PlaceDescription]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Places List"
        
        initializePDList()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddPlace))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    @objc func initializePDList() {
//        let pL = PlacesLibrary()
//        self.placeDescriptionList = pL.getPlaceDescriptionListFromJson()
        
        let parameters = [
            "jsonrpc": 2.0,
            "method": "getNames",
            "params": [],
            "id": 3
        ] as [String : Any]
        let url = "http://localhost:8080"
        jsonRPCGetPlaceNames(parameters: parameters, urlString: url)
    }
    
    func jsonRPCGetPlaceNames(parameters:[String:Any], urlString:String) {
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
                    let names = jsonData["result"] as! [String]
                    for name in names {
                        let pD = PlaceDescription()
                        pD.name = name
                        self.placeDescriptionList.append(pD)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    @objc func handleAddPlace() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEditViewController") as! AddEditViewController
        vc.placeDescriptionDelegate = self
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placeDescriptionList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = placeDescriptionList[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = placeDescriptionList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEditViewController") as! AddEditViewController
        vc.placeDescription = place
        vc.placeDescriptionDelegate = self
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            placeDescriptionList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}

extension PlacesTableViewController: AddEditPlaceDelegate {
    func addPlace(placeDescription: PlaceDescription) {
        self.dismiss(animated: true) {
            var flag:Bool = true
            for place in self.placeDescriptionList {
                if place.name == placeDescription.name {
                    flag = false
                    place.description = placeDescription.description
                    place.category = placeDescription.category
                    break
                }
            }
            if flag {
                self.placeDescriptionList.append(placeDescription)
            }
            self.tableView.reloadData()
        }
    }
}
