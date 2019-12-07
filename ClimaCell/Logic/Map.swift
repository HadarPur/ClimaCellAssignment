//
//  Map.swift
//  ClimaCell
//
//  Created by Hadar Pur on 07/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Map {
    func setupPin(record: CountriesData.CountriesObj, map: MKMapView) {
        let coords: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: record.latlng[0], longitude: record.latlng[1])

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coords, span: span)

        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords

        annotation.subtitle = record.capital!
        annotation.title = "\(record.name!)"
        
        map.addAnnotation(annotation)
    }
}
