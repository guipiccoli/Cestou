//
//  Model.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation

struct Product: Codable {
    var code: String
    var name: String
    var quantity: Double
    var unitPrice: Double
    var unity: String
    var productCategory: ProductCategory?
    var description: String {
        return "Quantity: \(quantity)\(unity) Code: \(code), Name: \(name), Unity Price: \(unitPrice), Category: \(String(describing: productCategory))"
    }
}

struct Shopping: Codable {
    var uniqueCode: String
    var products: [Product]
    var marketplace: Marketplace
    var date: String
    var balance: Double {
        return products.reduce(0.0) { $0 + $1.quantity * $1.unitPrice}
    }
    var description: String {
        let productList: String = products.reduce("") { $0.description + "\n" + $1.description}
        return "Unique Code: \(uniqueCode) \(marketplace.description)\nProducts: \(productList)\nAmount: R$\(balance)\nDate: \(date)"
    }
}

struct Marketplace: Codable {
    var name: String
    var address: String
    var cnpj: String
    var stateRegistration: String
    var description: String {
        return "Name: \(name), Address: \(address), CNPJ: \(cnpj), State Registration: \(stateRegistration)"
    }
}

struct User: Codable {
    var email: String
    var username: String
    var sessionToken: String
}

struct ProductCategory: Codable {
    var name: String
}

struct ProductHistory: Codable {
    var product: Product
    var shopping: Shopping
    var valueUnit: Double
    var unity: String
}

struct Balance: Codable {
    var year: Int
    var month: Int
    var incoming: Double
    var expense: Double
    var expenseProjected: Double
}
