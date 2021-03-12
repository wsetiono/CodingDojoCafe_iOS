//
//  LocationViewController.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let manager = LocationDataManager()
    
    var selectedCity:LocationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialize()
    }
    
    func set(selected cell:UITableViewCell, at indexPath: IndexPath) {
        if let city = selectedCity?.city {
            let data = manager.findLocation(by: city)
            if data.isFound {
                if indexPath.row == data.position {
                    cell.accessoryType = .checkmark
                }
                else { cell.accessoryType = .none }
            }
        }
        else {
            cell.accessoryType = .none
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Private Extension
private extension LocationViewController {
    // code goes here
    
    func initialize() {
        manager.fetch()
    }

}


// MARK: UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    // code goes here
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
      section: Int) -> Int{
        manager.numberOfItems()
    }


    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
//          IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier:
//                   "locationCell", for: indexPath) as UITableViewCell
//        cell.textLabel?.text = manager.locationItem(at:indexPath).full
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
       -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
                   "locationCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = manager.locationItem(at:indexPath).full
        set(selected: cell, at: indexPath)
        return cell
    }

}


//MARK: UITableViewDelegate
extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt
    indexPath:IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedCity = manager.locationItem(at:indexPath)
            tableView.reloadData()
        }
    }
}

    
