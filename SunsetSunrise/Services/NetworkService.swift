//
//  NetworkService.swift
//  SunsetSunrise
//
//  Created by Liliia Neskoromna on 20.11.2020.
//

import Foundation
import Alamofire
import GooglePlaces
import GoogleMaps
import SwiftyJSON


final class NetworkService {
    
    static var sharedNetworkService: NetworkService = {
        return NetworkService()
    }()
    
    static let googlePlacesApiKey: String = "AIzaSyA5xt5YbOp18AGfpAB1CbxNCJm-mkajJP8"
        
    func loadData(completion: @escaping (SunInfo) -> Void , lat: Double, long: Double) {
        
        let apiBaseUrl: String = "https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(long)"
        
        var sunInfo: SunInfo!
        
        AF.request(apiBaseUrl).responseJSON { response in
            
            switch response.result {
            case .success:
                
                guard let json = try? JSON(response.result.get()) else {
                    fatalError("Cannot get json")
                }
                
                let results = json["results"]
                
                let sunrise = results["sunrise"].stringValue
                let sunset = results["sunset"].stringValue
                
                sunInfo = SunInfo(sunrise: sunrise, sunset: sunset)
            
                completion(sunInfo)
            
            case .failure(_):
                print("error")
                completion(sunInfo)
            }
        }
    }
}
