//
//  Utils.swift
//  GeoServicesApp
//
//  Created by sambuddha nath on 3/25/21.
//

import Foundation

class Utils {
    
    @objc func jsonToString(json: AnyObject) -> String {
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                guard let convertedString = String(data: data1, encoding: String.Encoding.utf8) else { return "" } // the data will be converted to the string
                return convertedString // <-- here is ur string
            } catch let myJSONError {
                print(myJSONError)
            }
        return ""
    }
    
    @objc func convertStringToDictionary(text: String) -> [String:AnyObject] {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] ?? [:]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return [:]
    }
}
