//
//  MapDataManager.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import Foundation
import MapKit

class MapDataManager: DataManager {
 
    fileprivate var items:[CafeItem] = []
 
    var annotations:[CafeItem] {
        return items
    }
 
//    func fetch(completion:(_ annotations:[CafeItem]) -> ()){
//        if items.count > 0 { items.removeAll() }
//        for data in load(file: "MapLocations") {
//            items.append(CafeItem(dict: data))
//        }
//        completion(items)
//    }
    
    func fetch(completion:(_ annotations:[CafeItem]) -> ()){
        let manager = CafeDataManager()
        manager.fetch(by: "Boston", completionHandler: { (items) in
            self.items = items
            completion(items)
        })
    }

    
    //    fileprivate func loadData() -> [[String:AnyObject]] {
    //        guard let path = Bundle.main.path(forResource:
    //                         "MapLocations", ofType: "plist"),
    //        let items = NSArray(contentsOfFile: path) else {
    //            return [[:]]
    //        }
    //        return items as! [[String:AnyObject]]
    //    }

    func currentRegion(latDelta:CLLocationDegrees, longDelta:CLLocationDegrees) -> MKCoordinateRegion {
        guard let item = items.first else {
            return MKCoordinateRegion()
    }
        let span = MKCoordinateSpan(latitudeDelta: latDelta,
                   longitudeDelta: longDelta)
        return MKCoordinateRegion(center:item.coordinate, span:span)
    }

}
