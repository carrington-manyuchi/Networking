//
//  WeatherData.swift
//  Clima App
//
//  Created by Manyuchi, Carrington C on 2024/09/14.
//

import Foundation


struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Decodable {
    let temp: Double
}


struct Weather: Decodable {
    let description: String
    let id: Int
}
