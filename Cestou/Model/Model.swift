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
    var productCategory: ProductCategory
    var description: String {
        return "Quantity: \(quantity)\(unity) Code: \(code), Name: \(name), Unity Price: \(unitPrice), Category: \(productCategory.name)"
    }
}

struct Shopping: Codable {
    var accessKey: String
    var products: [Product]
    var marketplace: Marketplace
    var date: String
    var cost: Double
    var description: String {
        let productList: String = products.reduce("") { $0.description + "\n" + $1.description}
        return "Unique Code: \(accessKey) \(marketplace.description)\nProducts: \(productList)\nAmount: R$\(cost)\nDate: \(date)"
    }

    init(accessKey: String, products: [Product], marketplace: Marketplace, date: String) {
        self.accessKey = accessKey
        self.products = products
        self.marketplace = marketplace
        self.date = date
        cost = products.reduce(0.0) { $0 + $1.quantity * $1.unitPrice}
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
    var monthlyShoppings: [Shopping]?
    var description: String {
        return "Date: \(month)/\(year), Income: R$\(incoming), Expense: R$\(expense), Projected Expense: R$\(expenseProjected)"
    }
}

struct ProductCategory: Codable {
    var name: String = "Outros"
    
    var description: String {
        return "\(self.name)"
    }
    
    init(productName: String) {
        let _productName = productName.replacingOccurrences(of: "&", with: "")
        var arrayOfStrings = _productName.split(separator: " ")
        arrayOfStrings = arrayOfStrings.filter({$0.count > 2})
        for (categoryName, catalog) in categories {
            for string in arrayOfStrings {
                if catalog.contains(String(string).lowercased()) {
                    print(categoryName + " :: " + string)
                    self.name = categoryName
                    return
                }
            }
        }
        for (categoryName, catalog) in categories {
            for element in catalog {
                for string in arrayOfStrings {
                    if element.contains(String(string).lowercased()) {
                        print(element + " : " + string)
                        self.name = categoryName
                        return
                    }
                }
            }
        }
    }
}

var categories: [String: [String]] =
    [
        "Alimentos": [
            "bacon",
            "chester",
            "gordura vegetal",
            "hamburger",
            "iogurte",
            "leite",
            "linguica",
            "manteiga",
            "margarina",
            "mortadela",
            "nata",
            "pate",
            "peito de peru",
            "presunto",
            "queijo",
            "queijo ralado",
            "requeijao",
            "ricota",
            "salame",
            "ovo",
            "achocolatado",
            "acucar",
            "adocante",
            "arroz",
            "atum",
            "azeite",
            "azeitona",
            "batata palha",
            "baunilha",
            "biscoito",
            "bombom",
            "cafe",
            "caldo",
            "catchup",
            "cereal",
            "amendoim",
            "champignon",
            "chocolate",
            "chocolate granulado",
            "coco ralado",
            "creme de leite",
            "farinha de mandioca",
            "farinha de milho",
            "farinha de rosca",
            "farinha de trigo",
            "feijao",
            "fermento",
            "gelatina",
            "geleia",
            "leite",
            "leite condensado",
            "leite de coco",
            "lentilha",
            "macarrao",
            "maionese",
            "molho",
            "mostarda",
            "polpa de tomate",
            "polvilho",
            "sagu",
            "sal",
            "sal grosso",
            "salsicha",
            "sardinha",
            "sopa",
            "tempero",
            "abacate",
            "abacaxi",
            "abobrinha",
            "agriao",
            "alface",
            "alho",
            "banana",
            "batata",
            "berinjela",
            "beterraba",
            "brocolis",
            "cebola",
            "cenoura",
            "chuchu",
            "couve",
            "espinafre",
            "goiaba",
            "laranja",
            "maca",
            "mama",
            "manjerica",
            "melancia",
            "melao",
            "ovos",
            "pera",
            "pimentao",
            "repolho",
            "rucula",
            "salsinha",
            "temperinho verde",
            "tomate",
            "uva",
            "vagem",
            "frutas secas",
            "ervilha",
            "palmito",
            "milho",
            "pepino",
            "biscoito",
            "bolo",
            "doce",
            "pao",
            "salgado",
            "torta"
        ],
        "Higiene": [
            "absorvente",
            "acetona",
            "algodao",
            "antisseptico",
            "aparelho de barbear",
            "condicionador",
            "cortador de unhas",
            "cotonete",
            "creme de barbear",
            "desodorante",
            "escova de dente",
            "esmalte",
            "fio-dental",
            "fixador",
            "fraldas",
            "gel",
            "hidratante",
            "lamina de barbear",
            "lenco",
            "lixa",
            "pente",
            "pinca",
            "preservativo",
            "sabonete",
            "xampu",
            "talco"
        ],
        "Bebidas": [
            "agua",
            "agua de coco",
            "agua tonica",
            "cerveja",
            "champanhe",
            "licor",
            "refrigerante",
            "rum",
            "suco",
            "vinho",
            "vodca",
            "uisque",
            "cha"
        ],
        "Limpeza": [
            "sanitaria",
            "alcool",
            "alvejante",
            "amaciante",
            "desinfetante",
            "detergente",
            "esponja",
            "guardanapo",
            "inseticida",
            "lava-roupa",
            "limpa-vidro",
            "lustra-moveis",
            "palito de dente",
            "pano de limpeza",
            "pano de prato",
            "papel higienico",
            "purificador de ambientes",
            "sabao",
            "saco de lixo",
            "toalha de papel",
            "vassoura"
        ]
]
