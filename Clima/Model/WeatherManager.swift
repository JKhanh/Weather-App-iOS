//
//  WeatherModelManager.swift
//  Clima
//
//  Created by Khanh jonas on 11/07/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import Alamofire

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1995645e3d8734ec2fedcb2a25cae7b6&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(urlString)
    }
    
    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        AF.request(urlString).response { response in
            if let error = response.error {
                print(error)
                return
            }
            if let safeData = response.data {
                if let weather = parseJSON(weatherData: safeData) {
                    delegate?.weatherDidUpdate(weather: weather)
                }
            }
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, city: name, tempurature: temp)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}

protocol WeatherManagerDelegate {
    func weatherDidUpdate(weather: WeatherModel)
}
