//
//  ExploreViewController.swift
//  CodingDojoCafe
//
//  Created by William on 11/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    let manager = ExploreDataManager()
    
    var selectedCity:LocationItem?
    
    var headerView:ExploreHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case Segue.locationList.rawValue:
                showLocationList(segue: segue)
            case Segue.cafeList.rawValue:
                showCafeListing(segue: segue)
            default:
            print("Segue not added")
        }
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String,
         sender: Any?) -> Bool {
        if identifier == Segue.cafeList.rawValue {
            guard selectedCity != nil else {
                showAlert()
                return false
            }
            return true
        }
        return true
    }


}

// MARK: Private Extension
private extension ExploreViewController {
    // code goes here
    
    func initialize() {
        manager.fetch()
    }
    
    func showLocationList(segue:UIStoryboardSegue){
        guard let navController = segue.destination as? UINavigationController,
          let viewController = navController.topViewController as?
                               LocationViewController else {
            return
        }
        guard let city = selectedCity else { return }
        viewController.selectedCity = city
    }

    func showCafeListing(segue:UIStoryboardSegue) {
        if let viewController = segue.destination as? CafeListViewController,
             let city = selectedCity, let index = collectionView.indexPathsForSelectedItems?.first {
            viewController.selectedType = manager.explore(at: index).name
            viewController.selectedCity = city
        }
    }

    
    func showAlert() {
        let alertController = UIAlertController(title: "Location Needed",
           message: "Please select a location.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    

    @IBAction func unwindLocationCancel(segue:UIStoryboardSegue) {
       
    }
    
    @IBAction func unwindLocationDone(segue:UIStoryboardSegue){
        if let viewController = segue.source as? LocationViewController {
            selectedCity = viewController.selectedCity
            if let location = selectedCity {
                headerView.lblLocation.text = location.full
            }
        }
    }

    
}

// MARK: UICollectionViewDataSource
extension ExploreViewController: UICollectionViewDataSource {
     // code goes here
    
     //Code ini untuk menampilkan button di dalam CollectionReusableView

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        headerView = header as? ExploreHeaderView
        return headerView
    }

        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //20
            manager.numberOfItems()
        }
        
        func collectionView(_ collectionView: UICollectionView,
           cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                       "exploreCell", for: indexPath) as! ExploreCell
            let item = manager.explore(at: indexPath)
            cell.lblName.text = item.name
            cell.imgExplore.image = UIImage(named: item.image)
            return cell
        }
}
