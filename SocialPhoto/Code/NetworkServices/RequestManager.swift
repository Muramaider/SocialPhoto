//
//  NetworkManager.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 22/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

final class RequestManager {

    static  let shared  = RequestManager()
    static private let baseURL = "http://localhost:8080/"
    
    func getRequest(methodName: String, httpMethod: String, parametersBody: [String: String]?) -> URLRequest? {
        
        let url = String(format: RequestManager.baseURL + methodName)
        guard let serviceUrl = URL(string: url) else {
            return nil
        }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = httpMethod
        
        if let token = KeyChain.instance.readToken() {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let parameterDictionary = parametersBody,
            let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) {
            request.httpBody = httpBody
        }
        
        return request
    }
   
    func getErrorResponce(response: URLResponse?) -> String? {
        
        guard let response = response as? HTTPURLResponse else {
            return "Transfer error"
        }
        let statusCode = response.statusCode
        
        switch statusCode {
        case 200:
            return nil
        case 404:
            return "Not found"
        case 400:
            return "Bad request"
        case 401:
            return "Unauthorized"
        case 406:
            return "Not acceptable"
        case 422:
            return "Unprocessable"
        default:
            return "Transfer error"
        }
    }
}
