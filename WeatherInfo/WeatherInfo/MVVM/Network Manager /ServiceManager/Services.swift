//
//  Services.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation
typealias complitionHandler = (APIResult<Any>)->()
typealias parameter = [String:Any]

enum HttpMethods:String {
    case post = "POST"
    case get = "GET"
}
enum APIResult<ModelType> {
    case Success(ModelType)
    case failure(APIError)
}
enum Environment:EnvironmentalProtocol {
    case Development
    case Production
    var baseUrl: String{
        switch self {
        case .Development:
            return Path.BaseUrl
        case .Production:
            return ""
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .Development:
            return Serviceheader.urlEncoded
        case.Production:
            return Serviceheader.urlEncoded
        }
    }
    
   
}
protocol EnvironmentalProtocol {
    var baseUrl : String { get}
    var headers : [String:String] {get}
    
}
protocol RequestProtocol {
    var path : String {get set}
    var method: HttpMethods {get set}
    var parameter: parameter {get set}
  //  func checkResponse(complition:@escaping(_ response:Any)->Void)
   
}

protocol NetworkProtocol {
    associatedtype T:Decodable
    func decode(_ data: Data) -> T?
    func execute(urlrequest:URLRequest ,complition:@escaping(APIResult<Any>)->Void)
    func imageData(urlrequest:URLRequest ,complition:@escaping(Data?,APIError?)->Void)
}


class Services<T:Decodable>:NetworkProtocol {
    func imageData(urlrequest: URLRequest, complition: @escaping (Data?,APIError?) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlrequest){
            (data,response,error) in
            guard error == nil else{
                return complition(nil,APIError.requestFailed)
            }
            guard let data = data else{
                return complition(nil,APIError.notFound)
            }
           // let httpResponse = response as? HTTPURLResponse
            
  //             print(httpResponse)
//            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print(json)
         //   let result = decode(data)
           
            complition(data, nil)
        }
        dataTask.resume()
    
        
    }
    
    func decode(_ data: Data) -> T? {
        debugPrint(T.self, data)
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        } catch  {
            return nil
        }
    }
    
    func execute(urlrequest: URLRequest, complition: @escaping (APIResult<Any>) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlrequest){ [self]
            (data,response,error) in
            guard error == nil else{
                return complition(APIResult.failure(.requestFailed))
            }
            guard let data = data else{
                return complition(APIResult.failure(.notFound))
            }
  //          let httpResponse = response as? HTTPURLResponse
  //             print(httpResponse)
//            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print(json)
            let result = decode(data)
            guard result != nil else{
                return complition(APIResult.failure(.invalidData))
            }
            complition(APIResult.Success(result as Any))
        }
        dataTask.resume()
    }
}
extension RequestProtocol{
    private  func url(url:String)-> URL?{
    guard   var urlComponents = URLComponents(string:url) else {
        return nil
    }
    urlComponents.path = urlComponents.path + path
    urlComponents.queryItems = queryItems
    return urlComponents.url
    
    }
  private  var jsonBody:Data? {
    guard method == HttpMethods.post else {
        return nil
    }
    
    let dataParameters = parameter.reduce("") { (result, values) -> String in
        return result + "&\(values.key)=\(values.value)"
    }.data(using: .utf8)
    return dataParameters
    }
    private var queryItems: [URLQueryItem]? {
        guard method == HttpMethods.get else {
            return nil
        }
        let query = parameter.map { (key: String, value: Any) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
        print(query)
        return query
        
    }
    public func urlRequest(urlStr:String)-> URLRequest?{
        guard let url = url(url: urlStr) else {
            return nil
        }
    debugPrint(url)
        var urlrequest = URLRequest(url: url)
        urlrequest.httpBody = jsonBody
        urlrequest.httpMethod = method.rawValue
        urlrequest.allHTTPHeaderFields = Environment.Development.headers
        
        return urlrequest
        
    }
}
