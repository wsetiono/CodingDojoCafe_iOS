//
//  LocationItem.swift
//  CodingDojoCafe
//
//  Created by William on 13/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import Foundation

struct LocationItem {
    var state: String?
    var city: String?
}

extension LocationItem {
    init(dict: [String:AnyObject]) {
        self.state = dict["state"] as? String
        self.city = dict["city"] as? String
    }
 
    var full: String {
        guard let city = self.city, let state = self.state else { return "" }
        return "\(city), \(state)"
    }
}
