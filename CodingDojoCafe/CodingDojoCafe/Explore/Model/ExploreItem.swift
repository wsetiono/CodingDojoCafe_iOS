//
//  ExploreItem.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import Foundation

struct ExploreItem {
    var name: String
    var image: String
}

extension ExploreItem {
      init(dict:[String:AnyObject]){
          self.name = dict["name"] as! String
          self.image = dict["image"] as! String
      }
  }

