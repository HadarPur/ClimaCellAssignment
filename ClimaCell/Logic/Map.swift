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
        map.setupPin(record: record)
    }
}

extension MKMapView {
    func setupPin(record: CountriesData.CountriesObj) {
        let coords: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: record.latlng[0], longitude: record.latlng[1])

        let span = MKCoordinateSpan(latitudeDelta: 150, longitudeDelta: 150)
        let region = MKCoordinateRegion(center: coords, span: span)

        setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords

        annotation.subtitle = record.capital!
        annotation.title = "\(record.name!)"
        
        addAnnotation(annotation)
    }
}
