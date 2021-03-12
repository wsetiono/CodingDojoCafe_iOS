//
//  CafeDataManager.swift
//  CodingDojoCafe
//
//  Created by William on 13/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import Foundation

class CafeDataManager {
    
    private var items:[CafeItem] = []
    
    func fetch(by location:String, with filter:String = "All",
        completionHandler:(_ items:[CafeItem]) -> Void) {
        if let file = Bundle.main.url(forResource: location,
           withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
              
                let cafes = try JSONDecoder().decode([CafeItem].self,
                from: data)

                if filter != "All" {
                    items = cafes.filter({ ($0.cuisines.contains(filter))})
                }
                else { items = cafes }
            }
            catch {
                print("there was an error \(error)")
            }
        }
        completionHandler(items)
    }

    func numberOfItems() -> Int {
         return items.count
    }
    
    func cafeItem(at index:IndexPath) -> CafeItem {
         return items[index.item]
    }
    

    
    
}
