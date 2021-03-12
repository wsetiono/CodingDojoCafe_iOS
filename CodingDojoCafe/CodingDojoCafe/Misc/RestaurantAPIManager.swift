//
//  CafeAPIManager.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import Foundation

struct CafeAPIManager {

    static func loadJSON(file name:String) -> [[String:AnyObject]]{
        var items = [[String:AnyObject]]()
        guard let path = Bundle.main.path(forResource: name,
           ofType: "json"),let data = NSData(contentsOfFile: path) else {
            return [[:]]
        }
     
        do {
            let json = try JSONSerialization.jsonObject(with: data as
                       Data, options: .allowFragments) as AnyObject
            if let cafes = json as? [[String:AnyObject]] {
                items = cafes as [[String:AnyObject]]
            }
        }
        catch {
            print("error serializing JSON: \(error)")
            items = [[:]]
        }
        return items
    }

    
}
