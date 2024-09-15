//
//  WeatherManagaer.swift
//  Clima App
//
//  Created by Manyuchi, Carrington C on 2024/09/14.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f8c200300740e9affe7daea59ed32b71&units=metric"
    
    var delegate: WeatherManagerDelegate?

    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)

    }
    
    func performRequest(with urlString: String) {
        /// Four steps of networking
        /// 1. Create a url
        ///  2. Create a URLSession
        ///   3. Give session a task
        ///    4. Start the task
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    do {
                        let decoder =  JSONDecoder()
                        let decodedData = try decoder.decode(WeatherData.self, from: safeData)
                        let id = decodedData.weather[0].id
                        let temp = decodedData.main.temp
                        let name = decodedData.name
                        
                        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                        self.delegate?.didUpdateWeather(self, weather: weather)

                    } catch {
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
    
    
   
}


