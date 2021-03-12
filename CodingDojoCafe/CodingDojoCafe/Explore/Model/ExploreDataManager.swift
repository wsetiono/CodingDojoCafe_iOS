//
//  ExploreDataManager.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import Foundation

class ExploreDataManager: DataManager  {
    
    fileprivate var items:[ExploreItem] = []
    
       func fetch() {
           for data in load(file: "ExploreData") {
               items.append(ExploreItem(dict: data))
           }
       }
    
       func numberOfItems() -> Int {
           return items.count
       }

    
    func explore(at index:IndexPath) -> ExploreItem {
        return items[index.item]
    }
    
//    fileprivate func loadData() -> [[String: AnyObject]] {
//
//        guard let path = Bundle.main.path(forResource: "ExploreData",
//          ofType: "plist"), let items = NSArray(contentsOfFile: path)
//          else {
//                return [[:]]
//            }
//            return items as! [[String:AnyObject]]
//
//    }
    
}
