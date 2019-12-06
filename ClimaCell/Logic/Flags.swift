//
//  Flags.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation

class Flags {
     public func flagForCountry(country:String) -> String {
         let base : UInt32 = 127397
         var s = ""
         for v in country.unicodeScalars {
             s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
         }
         return String(s)
     }
}
