//
//  FilterItem.swift
//  CodingDojoCafe
//
//  Created by William on 13/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import Foundation

class FilterItem:NSObject {
    let filter:String
    let name:String

    init(dict:[String:AnyObject]){
        name = dict["name"] as! String
        filter = dict["filter"] as! String
    }
}
