//
//  ParseRequest.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 07/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct ParseRequest {
    private var request: URLRequest
    private let applicationId: String = "BUocb5yrgLRYaBj6MAJv79lnkjupls9U1tZXwK74"
    private let apiKey: String = "fhqaBdHbm66HuuVirZX4lAdtTCQEGOyRTEqIGkJm"
    private let contentType: String = "aplication/json"
    private let revocableSession: String = "1"
    private var sessionToken: String {
        if let _sessionToken = KeychainWrapper.standard.string(forKey: "sessionToken") {
            return _sessionToken
        }
        else {
            fatalError()
        }
    }
    // MARK :- Post Request instantiate
    init(url: URL, body: Data) {
        self.request = URLRequest(url: url)
        self.request.httpBody = body
        self.request.httpMethod = "POST"
        
        self.request.setValue(self.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        self.request.setValue(self.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        self.request.setValue(self.sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        self.request.setValue(self.contentType, forHTTPHeaderField: "Content-Type")
    }
    
    init(url: URL) {
        self.request = URLRequest(url: url)
        self.request.httpMethod = "GET"
        
        self.request.setValue(self.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        self.request.setValue(self.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        self.request.setValue(self.sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        self.request.setValue(self.revocableSession, forHTTPHeaderField: "X-Parse-Revocable-Session")
    }
    
    func getRequest() -> URLRequest {
        return self.request
    }
    
    
}
