//
//  APIError.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation

enum APIError: Error,Equatable,CustomStringConvertible {
  
    
    case notAuthenticated
    case notFound
    case invalidData
    case badRequest
    case requestFailed
    case networkProblem
    case unknown(HTTPURLResponse?)
    
    init(response:URLResponse) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil)
            return
        }
        switch response.statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .notAuthenticated
        case 404:
            self = .invalidData
        default:
            self = .unknown(response)
        }
    }
    var description: String{
        switch self {
        case .badRequest , .invalidData,.requestFailed:
            return ErrorMessage.Default.RequestFailed
        case .notAuthenticated:
            return ErrorMessage.Default.NotAuthorized
        case .networkProblem ,.unknown(_):
            return ErrorMessage.Default.ServerError
        case .notFound:
            return ErrorMessage.Default.NotFound
    
        }
    }
    
    
}
extension APIError:LocalizedError {
    public var errorDescription: String?{
        switch self {
        case .badRequest , .invalidData,.requestFailed:
            return ErrorMessage.Default.RequestFailed
        case .notAuthenticated:
            return ErrorMessage.Default.NotAuthorized
        case .networkProblem ,.unknown(_):
            return ErrorMessage.Default.ServerError
        case .notFound:
            return ErrorMessage.Default.NotFound
    
        }
    }
    
}
extension APIError {
    struct ErrorMessage {
        struct Default {
                  static let ServerError = "Server Error. Please, try again later."
                  static let NotAuthorized = "This information is not available."
                  static let NotFound = "Bad request error."
                  static let RequestFailed = "Weather Report supports only US locations."
              }
    }
}

