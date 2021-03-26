//
//  PlaceDescription.swift
//  GeoServicesApp
//
//  Created by sambuddha nath on 3/19/21.
//

import Foundation

class PlaceDescription: Codable {
    var name:String="Name"
    var description:String?
    var category:String?
    var addressTitle:String?
    var elevation:Double=0.0
    var latitude:Double=0.0
    var longitude:Double=0.0
}
