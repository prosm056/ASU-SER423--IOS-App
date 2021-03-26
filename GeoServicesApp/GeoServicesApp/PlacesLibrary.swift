//
//  PlacesLibrary.swift
//  GeoServicesApp
//
//  Created by sambuddha nath on 3/25/21.
//

import Foundation

class PlacesLibrary {
    
    public var jsonData = [String:AnyObject]()
    public var placeDescriptionList = [PlaceDescription]()
    
    init() {
       
    }
    
    func getPlaceDescriptionListFromJson() -> [PlaceDescription] {
        guard let path = Bundle.main.path(forResource: "places", ofType: "json") else {
            return []
        }
        let url = URL(fileURLWithPath: path)
        var result = Result()
        do {
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Result.self, from: jsonData)
            for rI: ResultItem in result.data {
                let pD = PlaceDescription()
                pD.name = rI.name
                pD.description = rI.description
                pD.category = rI.category
                placeDescriptionList.append(pD)
            }
        } catch {
            print("Error while getting data from json: \(error)" )
        }
        return self.placeDescriptionList
    }
}
