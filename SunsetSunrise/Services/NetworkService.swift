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

enum LoadError: Error {
    case noDataAvailable
    case canNotProcessData
}

final class NetworkService {
    
    let urlresource: URL
    
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init (lat: Double, lon: Double) {
        let resourceString = "https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(lon)"
        
        guard let urlresource = URL(string: resourceString) else { fatalError() }
        self.urlresource = urlresource
    }
    
    //    static var sharedNetworkService: NetworkService = {
    //        return NetworkService(lat: <#Double#>, lon: <#Double#>)
    //    }()
    
    static func loadData (completion: @escaping(Result<SunInfo, LoadError>) -> Void) {
        
        var sunInfo: SunInfo!
        
        AF.request(urlresource).responseJSON { response in
            
            guard let jsonData = response.data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let weatherResponse = try NetworkService.jsonDecoder.decode(SunInfo.self, from: jsonData)
                let weatherDetails = weatherResponse
                completion(.success(weatherDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
    }
}
