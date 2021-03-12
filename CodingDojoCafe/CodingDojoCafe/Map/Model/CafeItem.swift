//
//  CafeItem.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import UIKit
import MapKit

class CafeItem: NSObject, MKAnnotation, Decodable  {

    var name: String?
    var cuisines:[String] = []
    var lat: Double?
    var long: Double?
    var address: String?
    var postalCode: String?
    var state: String?
    var imageURL: String?
    var restaurantID:Int?

    
    enum CodingKeys: String, CodingKey {
        case name
        case cuisines
        case lat
        case long
        case address
        case postalCode = "postal_code"
        case state
        case imageURL = "image_url"
        case restaurantID = "id"
    }

    
    var title: String? {
           return name
       }
    
    var subtitle: String? {
        if cuisines.isEmpty { return "" }
        else if cuisines.count == 1 { return cuisines.first }
        else { return cuisines.joined(separator: ", ") }
    }
    
    var coordinate: CLLocationCoordinate2D {
       guard let lat = lat, let long = long else
                       { return CLLocationCoordinate2D() }
       return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

}
