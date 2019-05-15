//
//  DataService.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 03/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation

struct DataService {
    
    static private let url: String = "http://api.cestou.mocka.site/parse"
    static private let session = URLSession.shared
    
    static func saveShopping(shopping: Shopping, completionHandler completion: @escaping (Bool) -> Void) {
        guard
            let _url = URL(string: "\(self.url)/functions/saveShopping")
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
        if let requestBody = String(data: body, encoding: .utf8){
            print(requestBody)
        }
        
        let parseRequest = ParseRequest(url: _url, body: body)
        
        let task = session.dataTask(with: parseRequest.getRequest()) { (data, response, error) in
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
    
    static func getShopping(month: Int, completionHandler completion: @escaping (Balance?) -> Void) {
        guard
            let _url = URL(string: "\(self.url)/functions/monthlyBalance/\(month)")
            else {
                print("error trying to generate url")
                completion(nil)
                return
            }
        
        let parseRequest = ParseRequest(url: _url)
        
        let task = session.dataTask(with: parseRequest.getRequest()) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                completion(nil)
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    if (response.statusCode != 400) {
                        completion(nil)
                    }
                }
                if let data = data, let balance = try? JSONDecoder().decode(Balance.self, from: data) {
                    print("data: \(balance.description)")
                    completion(balance)
                }
            }
        }
        task.resume()
        
    }

    static func reqNewUser(body : [String: String], onCompletion: @escaping (_ result: [String:Any]) -> Void) {
        guard let urlComponents = URLComponents(string: self.url + "/users") else { return onCompletion(["error": "Error parsing url."])}
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
    
    static func logIn( email: String, password: String, onCompletion: @escaping (_ result: [String:Any]) -> Void) {
        guard let urlComponents = URLComponents(string: self.url + "/login?username=" + email + "&password=" + password) else { return onCompletion(["error": "Error parsing url."])}
        guard let url = urlComponents.url else { return onCompletion(["error": "Error parsing url."])}
        
        let parseRequest = ParseRequest(url: url)
        
        self.session.dataTask(with: parseRequest.getRequest() as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                onCompletion(["error": "No response."])
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    onCompletion(json)
                }
            } catch let error {
                print(error.localizedDescription)
                onCompletion( ["error": "Error parsing response json."])
            }
        }).resume()
    }
    

    static func verifySessionToken(completionHandler completion: @escaping (_ result: Bool) -> Void) {
        guard
            let urlComponents = URLComponents(string: self.url + "/users/me"),
            let url = urlComponents.url else {
            print("error trying to generate url")
            completion(false)
            return
        }
        let parseRequest = ParseRequest(url: url)
        
        let task = session.dataTask(with: parseRequest.getRequest()) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                completion(false)
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    if response.statusCode == 200 {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
            }
        }
        task.resume()
    }
     
    static func saveBalance(body : [String: Double], onCompletion: @escaping (_ result: [String:Any]) -> Void) {
        guard let urlComponents = URLComponents(string: self.url + "/functions/saveBalance") else { return onCompletion(["error": "Error parsing url."])}
        guard let url = urlComponents.url else { return onCompletion(["error": "Error parsing url."])}
        var _body: Data = Data.init()
        
        do {
            _body = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            onCompletion(["error": "Error parsing data json."])
        }
        
        let parseRequest = ParseRequest(url: url, body: _body)
        
        self.session.dataTask(with: parseRequest.getRequest() , completionHandler: { data, response, error in
            guard error == nil else {
                onCompletion(["error": "No response."])
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    onCompletion(json)
                }
            } catch let error {
                print(error.localizedDescription)
                onCompletion( ["error": "Error parsing response json."])
                
            }
        }).resume()

    }
    
    static func getDashboard(completionHandler completion: @escaping (_ result: [Balance]?) -> Void) {
        let date = Date()
        var result: [Balance] = []
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        guard
            let _url = URL(string: "\(self.url)/functions/Dashboard/\(year)")
            else {
                print("error trying to generate url")
                completion(nil)
                return
        }
        
        let parseRequest = ParseRequest(url: _url)
        
        let task = session.dataTask(with: parseRequest.getRequest()) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                completion(nil)
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    if (response.statusCode != 400) {
                        completion(nil)
                    }
                }
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    for (_, balance) in json {
                        if let _balance = balance as? Balance {
                            result.append(_balance)
                        }
                    }
                    completion(result)
                }
            }
        }
        task.resume()
        
    }
    
    static func reqPassReset(body : [String: String], onCompletion: @escaping (_ result: [String:Any]) -> Void) {
        guard let urlComponents = URLComponents(string: self.url + "/requestPasswordReset") else { return onCompletion(["error": "Error parsing url."])}
        guard let url = urlComponents.url else {
            onCompletion(["error": "Error parsing url."])
            return
        }
        var _body = Data.init()
        
        do {
            _body = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            onCompletion(["error": "Error parsing data json."])
        }
        
        let parseRequest = ParseRequest(url: url, body: _body)
        
        self.session.dataTask(with: parseRequest.getRequest() , completionHandler: { data, response, error in
            guard error == nil else {
                onCompletion(["error": "No response."])
                return
            }
            onCompletion(["success":"true"])

        }).resume()
    }
}
