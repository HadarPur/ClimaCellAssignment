//
//  Weather.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation

class Weather {
    
    func getWeather(area: CountriesData.CountriesObj, callback: @escaping (Array<ClimaCellAPI.ClimaCellObj>) -> (), callbackError: @escaping () -> ()) {
        ClimaCellAPI().getDataFromClimaCellAPI(area: area, callback: callback, callbackError: callbackError)
    }
    
}
