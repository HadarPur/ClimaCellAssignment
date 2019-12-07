//
//  CountriesData.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class Countries {
    
    static let shared = Countries()
    let CData = CountriesData()
    
    func getCountries() -> [CountriesData.CountriesObj] {
        return CData.getCountriesFromURL()
    }

    func readAllData(callback: @escaping () -> (), callbackError: @escaping () -> ()) {
        CData.config(callback: callback, callbackError: callbackError)
    }
    
    func getLocationForSpecificCapital(capitalObj: CountriesData.CountriesObj, callback: @escaping (CLLocation) -> (), callbackError: @escaping () -> ()) {
        CData.getCapitalMapLocation(capital: capitalObj.capital!, country: capitalObj.name!, locationCallback: callback, callbackError: callbackError)
    }
}
