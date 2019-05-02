//
//  Model.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation

struct Product {
    var code: String
    var name: String
    var quantity: Double
    var unitPrice: Double
    var unity: String
    var description: String {
        return "Quantity: \(quantity)\(unity) Code: \(code), Name: \(name), Unity Price: \(unitPrice)"
    }
}

struct Shopping {
    var products: [Product]
    var marketplace: Marketplace
    var date: String
    var balance: Double {
        return products.reduce(0.0) { $0 + $1.quantity * $1.unitPrice}
    }
    var description: String {
        let productList: String = products.reduce("") { $0.description + "\n" + $1.description}
        return "\(marketplace.description)\nProducts: \(productList)\nAmount: R$\(balance)\nDate: \(date)"
    }
}

struct Marketplace {
    var name: String
    var address: String
    var cnpj: String
    var stateRegistration: String
    var description: String {
        return "Name: \(name), Address: \(address), CNPJ: \(cnpj), State Registration: \(stateRegistration)"
    }
}

struct User {
    var username: String
    var email: String
    var fullname: String
}

struct ProductCategory {
    var name: String
}

struct ProductHistory {
    var product: Product
    var shopping: Shopping
    var valueUnit: Double
    var unity: String
}
