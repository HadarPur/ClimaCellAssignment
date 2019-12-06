//
//  Weather.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation

class Weather {
    
    func getWeater(area: CountriesData.CountriesObj, callback: @escaping (Array<ClimaCellAPI.ClimaCellObj>) -> ()) {
        ClimaCellAPI().getDataFromClimaCellAPI(area: area, callback: callback)
    }
    
}
