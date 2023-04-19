//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation
class WeatherManager: RequestProtocol {
    var path: String = ""
    
    var method: HttpMethods = .get
    
    var parameter: parameter = ["":""]
    
    let services = Services<WeatherModel>()
    
    func weatherResponse(place:String,complition:@escaping(Result<WeatherModel?,APIError>)->()){
        path = "/data/2.5/weather"
        let placeStr = place
        parameter = ["q" :placeStr,"appid":Path.appId]
        guard let urlrequest = urlRequest(urlStr: Environment.Development.baseUrl) else {
            return
        }
        
        services.execute(urlrequest: urlrequest) { (result) in
            switch result {
            case .Success(let response):
                complition(.success(response as? WeatherModel))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func imageResponse(icon:String,complition:@escaping(Result<Data,APIError>)->()){
        parameter = ["":""]
        path =  "/img/wn/" + icon  + "@2x.png"
        guard let urlrequest = urlRequest(urlStr: "https://openweathermap.org") else {
            return
        }
        services.imageData(urlrequest: urlrequest) { (data, error) in
            complition(.success(data!))
           // complition(.failure(error ?? APIError.badRequest))
         
        }
    }
}
