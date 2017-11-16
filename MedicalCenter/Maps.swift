//
//  Maps.swift
//  MedicalCenter
//
//  Created by D7703_22 on 2017. 11. 16..
//  Copyright © 2017년 D7703_22. All rights reserved.
//

import UIKit
import MapKit

class Maps: UIViewController, MKMapViewDelegate {
    
    var tits = ""
    var tell = ""
    var geos = ""

    var annotations = [MKPointAnnotation]()
    
    @IBOutlet var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(geos , completionHandler: { placemarks, error in
            
            if error != nil {
                print(error!)
                return
            }
            
            if let myPlacemarks = placemarks {
                let myPlacemark = myPlacemarks[0]
                
                let annotation = MKPointAnnotation()
                annotation.title = self.tits
                annotation.subtitle = self.tell
                
                if let myLocation = myPlacemark.location {
                    annotation.coordinate = myLocation.coordinate
                    self.annotations.append(annotation)
                }
            }
            self.myMapView.showAnnotations(self.annotations, animated: true)
            self.myMapView.addAnnotations(self.annotations)
            
        })
    }
}
