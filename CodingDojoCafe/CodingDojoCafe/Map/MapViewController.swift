//
//  MapViewController.swift
//  CodingDojoCafe
//
//  Created by William on 12/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = MapDataManager()
    var selectedCafe:CafeItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier! {
            case Segue.showDetail.rawValue:
                showCafeDetail(segue: segue)
            default:
                print("Segue not added")
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
private extension MapViewController {
    // code goes here
    
    func initialize() {

            mapView.delegate = self
        
           manager.fetch { (annotations) in
           addMap(annotations)
           }
           
       
       }

       func addMap(_ annotations:[CafeItem]) {
           
           mapView.setRegion(manager.currentRegion(latDelta: 0.5,
              longDelta: 0.5), animated: true)
           mapView.addAnnotations(manager.annotations)
       }
       
       func showCafeDetail(segue:UIStoryboardSegue){
           if let viewController = segue.destination as?
               CafeDetailViewController,
               let cafe = selectedCafe {
                viewController.selectedCafe = cafe
           }
       }

}

// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    // code goes here
    func mapView(_ mapView: MKMapView, annotationView view:
      MKAnnotationView, calloutAccessoryControlTapped control:
      UIControl){
        
        guard let annotation = mapView.selectedAnnotations.first else { return }
        selectedCafe = annotation as? CafeItem
        
        self.performSegue(withIdentifier: Segue.showDetail.rawValue,
          sender: self)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        let identifier = "custompin"
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        var annotationView: MKAnnotationView?
        if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = customAnnotationView
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            av.rightCalloutAccessoryView = UIButton(type:.detailDisclosure)
            annotationView = av
        }
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "custom-annotation")
        }
        return annotationView
    }

}
