//
//  Network.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON

class APIManager {
    
    typealias parameters = [String: Any]
    static let baseUrl = "https://gist.github.com/mustafagunes/"
    
    enum ApiResult {
        case success(JSON)
        case failure(RequestError)
    }
    
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    static func requestData(url: String, method: HTTPMethod, parameters: parameters?, completion: @escaping (ApiResult) -> Void) {
        let header =  ["Content-Type": "application/x-www-form-urlencoded"]
        var urlRequest = URLRequest(url: URL(string: baseUrl+url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            let parametersData = parameters.reduce("") { (result, param) -> String in
                return result + "&\(param.key)=\(param.value as! String)"
            }.data(using: .utf8)
            urlRequest.httpBody = parametersData
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                completion(ApiResult.failure(.connectionError))
            }
            else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let responseJson = try JSON(data: data)
                    print("responseCode : \(responseCode.statusCode)")
                    print("responseJSON : \(responseJson)")
                    switch responseCode.statusCode {
                    case 200:
                        completion(ApiResult.success(responseJson))
                    case 400...499:
                        completion(ApiResult.failure(.authorizationError(responseJson)))
                    case 500...599:
                        completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
                }
                catch let parseJSONError {
                    completion(ApiResult.failure(.unknownError))
                    print("error on parsing request to JSON : \(parseJSONError)")
                }
            }
        }.resume()
    }
}
