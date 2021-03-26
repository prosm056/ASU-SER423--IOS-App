//
//  LocalPlaceManager.swift
//  GeoServicesApp
//
//  Created by sambuddha nath on 3/19/21.
//

import Foundation

class LocalPlaceManager {
     
    public func saveUser(placeDescription: PlaceDescription) {
        do {
             
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(placeDescription)
            let json = String(data: jsonData, encoding: .utf8) ?? "{}"
             
            let defaults: UserDefaults = UserDefaults.standard
            defaults.set(json, forKey: "user")
            defaults.synchronize()
             
        } catch {
            print(error.localizedDescription)
        }
    }
     
    public func getUser() -> PlaceDescription {
        do {
            if (UserDefaults.standard.object(forKey: "user") == nil) {
                return PlaceDescription()
            } else {
                let json = UserDefaults.standard.string(forKey: "user") ?? "{}"
                 
                let jsonDecoder = JSONDecoder()
                guard let jsonData = json.data(using: .utf8) else {
                    return PlaceDescription()
                }
                 
                let placeDescription: PlaceDescription = try jsonDecoder.decode(PlaceDescription.self, from: jsonData)
                return placeDescription
            }
        } catch {
            print(error.localizedDescription)
        }
        return PlaceDescription()
    }
     
    public func removeUser() {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: "user")
        defaults.synchronize()
    }
}
