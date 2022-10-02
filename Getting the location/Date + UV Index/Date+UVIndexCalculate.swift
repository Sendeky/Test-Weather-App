//
//  Date+UVIndexCalculate.swift
//  Getting the location
//
//  Created by RuslanS on 9/29/22.
//

import Foundation


let date = Date()
let calendar = Calendar.current
let hour = calendar.component(.hour, from: date)

struct UVIndex {
    static var UVIndex = 0
}

class DateUVIndexCalculate {
    
}

extension DateUVIndexCalculate {
    func calculateUVIndex() {
        switch hour {
        case 0:
            UVIndex.UVIndex = 0
        case 1:
            UVIndex.UVIndex = 0
        case 2:
            UVIndex.UVIndex = 0
        case 3:
            UVIndex.UVIndex = 0
        case 4:
            UVIndex.UVIndex = 0
        case 5:
            UVIndex.UVIndex = 0
        case 6:
            if WeatherData.weatherDesc == "clear sky" {
                UVIndex.UVIndex = 2
            }
        case 7:
            if WeatherData.weatherDesc == "clear sky" {
                UVIndex.UVIndex = 2
            }
        case 19:
            UVIndex.UVIndex = 8
        default:
            UVIndex.UVIndex = 5
        }
    }
}
