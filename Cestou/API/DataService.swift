//
//  DataService.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 03/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation

struct DataService {
    
    static private let url: String = "https://parseapi.back4app.com/functions/saveShopping"
    static private let token = "r:3df5169beb74f5ea36c16e2d5a169806"

    static func saveShopping(shopping: Shopping, completionHandler completion: @escaping (Bool) -> Void) {
        guard
            let _url = URL(string: url)
            else {
                print("error trying to generate url")
                completion(false)
                return
        }
        
        
        guard let body = try? JSONEncoder().encode(shopping) else {
            print("error trying to encode json data")
            completion(false)
            return
        }
                
        var request = URLRequest(url: _url)
        request.setValue("BUocb5yrgLRYaBj6MAJv79lnkjupls9U1tZXwK74", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("fhqaBdHbm66HuuVirZX4lAdtTCQEGOyRTEqIGkJm", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(token, forHTTPHeaderField: "X-Parse-Session-Token")
        request.httpMethod = "POST"
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                completion(false)
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    completion(false)
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                    completion(false)
                }
            }
        }
        task.resume()
        
    }
    

    
}
