//
//  Weather.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation

class Weather {
    
    static let shared = Weather()
    private let ClimaCellData = ClimaCellAPI()
    
    func getWeather(capitalObj: CountriesData.CountriesObj, callback: @escaping (Array<ClimaCellAPI.ClimaCellObj>) -> (), callbackError: @escaping () -> ()) {
        ClimaCellData.getDataFromClimaCellDailyAPI(capitalObj: capitalObj, callback: callback, callbackError: callbackError)
    }
    
    func getWeatherFor6Hours(capitalObj: CountriesData.CountriesObj, callback: @escaping (Array<ClimaCellAPI.ClimaCellObj6Hours>) -> (), callbackError: @escaping () -> ()) {
        ClimaCellData.getDataFromClimaCellAPI6Hours(capitalObj: capitalObj, callback: callback, callbackError: callbackError)
    }
    
    func getCapitalDailyWeather(capitalObj: CountriesData.CountriesObj) -> [ClimaCellAPI.ClimaCellObj] {
        return ClimaCellData.getClimaCellDailyDataWheather(capitalObj: capitalObj)
    }
}
