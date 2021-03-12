//
//  CafeDetailViewController.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import UIKit
import MapKit

class CafeDetailViewController: UITableViewController {

    // Nav Bar
    @IBOutlet weak var btnHeart:UIBarButtonItem!
    
    // Cell One
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCuisine: UILabel!
    @IBOutlet weak var lblHeaderAddress: UILabel!
    
    // Cell Two
    @IBOutlet weak var lblTableDetails: UILabel!
    
    // Cell Three
    @IBOutlet weak var lblOverallRating: UILabel!
    
    @IBOutlet weak var ratingView: RatingsView!
    
    // Cell Eight
    @IBOutlet weak var lblAddress: UILabel!
    
    // Cell Nine
    @IBOutlet weak var imgMap: UIImageView!
    
    var selectedCafe: CafeItem?
    
    let manager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        dump(selectedCafe as Any) 
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if let identifier = segue.identifier {
//            switch identifier {
//            case Segue.showReview.rawValue:
//                showReview(segue: segue)
//            default:
//                print("Segue not added")
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let identifier = segue.identifier {
            switch identifier {
            case Segue.showReview.rawValue:
                showReview(segue: segue)
            case Segue.showPhotoFilter.rawValue:
                showPhotoFilter(segue: segue)
            default:
                print("Segue not added")
            }
        }
    }



}


private extension CafeDetailViewController {

    @IBAction func unwindReviewCancel(segue:UIStoryboardSegue) {}
    
    func showReview(segue:UIStoryboardSegue) {
        guard let navController = segue.destination as?
                                  UINavigationController,
          let viewController = navController.topViewController
                               as?
          ReviewFormViewController else {
            return
        }
        viewController.selectedRestaurantID = selectedCafe?.restaurantID
    }
    
    func showPhotoFilter(segue:UIStoryboardSegue){
        guard let navController = segue.destination as?
                                  UINavigationController,
       let viewController = navController.topViewController as?
        PhotoFilterViewController else {
            return
        }
        viewController.selectedRestaurantID = selectedCafe?.restaurantID
    }


//
//    func createRating() {
//        ratingView.rating = 3.5
//        ratingView.isEnabled = true
//    }

    func createRating() {
        ratingView.isEnabled = false
        if let id = selectedCafe?.restaurantID {
            let value = manager.fetchRestaurantRating(by: id)
            ratingView.rating = CGFloat(value)
            if value.isNaN {
                lblOverallRating.text = "0.0"
            } else {
                let roundedValue = ((value * 10).rounded()/10)
                lblOverallRating.text = "\(roundedValue)"
            }
        }
    }

    
    func initialize() {
        setupLabels()
        createMap()
        createRating()
    }

    
   func setupLabels() {
        guard let cafe = selectedCafe else { return }
        if let name = cafe.name {
            lblName.text = name
            title = name
        }
        if let cuisine = cafe.subtitle {
            lblCuisine.text = cuisine
        }
        if let address = cafe.address {
            lblAddress.text = address
            lblHeaderAddress.text = address
        }
        lblTableDetails.text = "Table for 7, tonight at 10:00 PM"
    }
    
    func createMap() {
        guard let annotation = selectedCafe,
           let long = annotation.long,
           let lat = annotation.lat else { return }
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        takeSnapShot(with: location)
    }
    
    func takeSnapShot(with location: CLLocationCoordinate2D){
     
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        var loc = location
        let polyline = MKPolyline(coordinates: &loc, count: 1 )
        let region = MKCoordinateRegion(polyline.boundingMapRect)
     
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: 340, height: 208)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.pointOfInterestFilter = .includingAll
     
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start() { snapshot, error in guard
               let snapshot = snapshot else { return }
                 UIGraphicsBeginImageContextWithOptions(mapSnapshotOptions.size,
                    true, 0)
                 snapshot.image.draw(at: .zero)
     
            let identifier = "custompin"
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
     
            let pinView = MKPinAnnotationView(annotation: annotation,
                          reuseIdentifier: identifier)
            pinView.image = UIImage(named: "custom-annotation")!
            let pinImage = pinView.image
            var point = snapshot.point(for:location)
    
            let rect = self.imgMap.bounds
            if rect.contains(point) {
                let pinCenterOffset = pinView.centerOffset
                point.x -= pinView.bounds.size.width/2
                point.y -= pinView.bounds.size.height/2
                point.x += pinCenterOffset.x
                point.y += pinCenterOffset.y
                pinImage?.draw(at: point)
            }
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    self.imgMap.image = image
                }
            }
        }
    }


}
