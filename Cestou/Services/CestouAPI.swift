//
//  CestouAPI.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation

class CestouAPI {
    private let session = URLSession.shared
    private let baseURL: String = "https://parseapi.back4app.com/"
    
    func reqNewUser(body : [String: String], onCompletion: @escaping (_ result: [String:Any]) -> Void) {
        guard let urlComponents = URLComponents(string: baseURL + "users") else  { return onCompletion(["error": "Error parsing url."])}
        guard let url = urlComponents.url else { return onCompletion(["error": "Error parsing url."])}
        let _body: Data

        do {
            _body = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return onCompletion(["error": "Error parsing data json."])
        }
        
        let parseRequest = ParseRequest(url: url, body: _body)
        
        self.session.dataTask(with: parseRequest.getRequest() , completionHandler: { data, response, error in
            guard error == nil else {
                return onCompletion(["error": "No response."])
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    return onCompletion(json)
                }
            } catch let error {
                print(error.localizedDescription)
                return onCompletion( ["error": "Error parsing response json."])
                
            }
        }).resume()
    }
    
    func logIn( email: String, password: String, onCompletion: @escaping (_ result: [String:Any]) -> Void) {
        guard let urlComponents = URLComponents(string: baseURL + "login?username=" + email + "&password=" + password) else { return onCompletion(["error": "Error parsing url."])}
        guard let url = urlComponents.url else { return onCompletion(["error": "Error parsing url."])}
        
        let parseRequest = ParseRequest(url: url)
        
        self.session.dataTask(with: parseRequest.getRequest() as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return onCompletion(["error": "No response."])
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    return onCompletion(json)
                }
            } catch let error {
                print(error.localizedDescription)
                return onCompletion( ["error": "Error parsing response json."])
                
            }
        }).resume()
    }
}
