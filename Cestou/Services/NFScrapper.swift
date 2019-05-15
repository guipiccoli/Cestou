//
//  NFScrapper.swift
//  Cestou
//
//  Created by Eduardo Ribeiro on 02/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import Foundation
import SwiftSoup

struct NFScrapper {
    
    private static func getNFCUrl(url: String, completionHandler completion: @escaping (String?) -> Void) {
        var document: Document = Document.init("")
        var elements: Elements = Elements.init()
        var nfcUrl: String = ""
        guard let _url = URL(string: url) else {
            completion(nil)
            return
        }
        let urlSession = URLSession.shared
        _ = urlSession.dataTask(with: _url) { (data, response, error) in
            guard
                let error = error
                else {
                    guard
                        let unwrappedData = data,
                        let html = String(data: unwrappedData, encoding: .utf8)
                        else {
                            print("error trying to generate hmtl")
                            completion(nil)
                            return
                    }
                    do{
                        document = try SwiftSoup.parse(html)
                        elements = try document.getElementsByTag("iframe")
                        nfcUrl = try elements.array()[0].attr("src")
                    }
                    catch {
                        print("error parsing document")
                    }
                    completion(nfcUrl)
                    return
            }
            
            print(error.localizedDescription)
            completion(nil)
            return
            
            }.resume()
    }
    
    static func getShopping(url: String, completionHandler completion: @escaping (Shopping?) -> Void) {
        getNFCUrl(url: url) { (urlNfc) in
            guard
                let _urlNfc = urlNfc,
                let _url = URL(string: _urlNfc)
                else {
                    print("error trying to generate url")
                    completion(nil)
                    return
            }
            let urlSession = URLSession.shared
            _ = urlSession.dataTask(with: _url) { (data, response, error) in
                guard
                    let error = error
                    else {
                        guard
                            let unwrappedData = data,
                            let html = String(data: unwrappedData, encoding: .ascii)
                            else {
                                print("error decoding datagram")
                                completion(nil)
                                return
                        }
                        
                        guard let products = self.getProducts(html: html) else {
                            print("error trying to parse product list info")
                            return
                        }
                        guard let marketplace = self.getShoppingMarketplace(html: html) else {
                            print("error trying to parse marketplace info")
                            return
                                
                        }
                        guard let date = self.getShoppingDate(html: html) else {
                            print("error trying to parse date info")
                            return
                            
                        }

                        guard let uniqueCode = self.getShoppingUniqueCode(html: html) else {
                            print("error trying to parse Unique Code info")
                            return
                            
                        }
                        
                        completion(Shopping(accessKey: uniqueCode, products: products, marketplace: marketplace, date: date))
                        return
                }
                
                print(error.localizedDescription)
                completion(nil)
                return
                
                }.resume()
        }
        
    }
    
    public static func getProducts(html: String) -> [Product]? {
        
        var document: Document = Document.init("")
        var elements: Elements = Elements.init()
        var result: [Product] = []
        
        do{
            document = try SwiftSoup.parse(html)
            elements = try document.getElementsByClass("NFCCabecalho")
            elements = try elements.array()[3].getElementsByTag("tr")
        }
        catch {
            print("error parsing document")
        }
        
        var products = elements.array() as [Element]
        products.remove(at: 0)
        
        do {
            for product in products {
                let code = try product.child(0).text()
                let name = try product.child(1).text().replacingOccurrences(of: "&", with: "")
                let _quantity = try product.child(2).text().replacingOccurrences(of: ",", with: ".")
                let unity = try product.child(3).text()
                let _valUnit = try product.child(4).text().replacingOccurrences(of: ",", with: ".")
                guard
                    let quantity = Double(_quantity),
                    let valUnit = Double(_valUnit)
                    else {
                        print("quantity fields bad formating")
                        return nil
                }
                result.append(Product(code: code, name: name, quantity: quantity, unitPrice: valUnit, unity: unity, productCategory: ProductCategory(productName: name)))
            }
        }
        catch{
            print("error trying to populate array of products")
        }
        return result
    }
    
    private static func getShoppingDate(html: String) -> String? {
        var document: Document = Document.init("")
        var elements: Elements = Elements.init()
        var date: String = ""
        
        do{
            document = try SwiftSoup.parse(html)
            elements = try document.getElementsByClass("NFCCabecalho_Subtitulo")
            let elem = try elements.array()[2].text()
            
            date = convertDateFromBRtoEN(stringDate: elem)

        }
        catch {
            print("error parsing document")
        }
        
        return date
    }
    
    private static func getShoppingUniqueCode(html: String) -> String? {
        var document: Document = Document.init("")
        var elements: Elements = Elements.init()
        var uniqueCode: String = ""
        
        do{
            document = try SwiftSoup.parse(html)
            elements = try document.getElementsByClass("NFCCabecalho_Subtitulo")
            uniqueCode = try elements.array()[5].text()
        }
        catch {
            print("error parsing document")
        }
        
        return uniqueCode
    }
    
    private static func getShoppingMarketplace(html: String) -> Marketplace? {
        var document: Document = Document.init("")
        var elements: Elements = Elements.init()
        var cnpj: String = ""
        var address: String = ""
        var name: String = ""
        var stateRegistration: String = ""
        do{
            document = try SwiftSoup.parse(html)
            elements = try document.getElementsByClass("NFCCabecalho_Subtitulo1")
            let marketPlaceInfo = try elements.array()[0].text().split(separator: " ")
            cnpj = marketPlaceInfo[1].replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "")
            stateRegistration = String(marketPlaceInfo[4])
            
            document = try SwiftSoup.parse(html)
            elements = try document.getElementsByClass("NFCCabecalho_Subtitulo1")
            address = try elements.array()[1].text()
            
            document = try SwiftSoup.parse(html)
            elements = try document.getElementsByClass("NFCCabecalho_Subtitulo")
            name = try elements.array()[0].text()
        }
        catch {
            print("error parsing document")
            return nil
        }
        return Marketplace(name: name, address: address, cnpj: cnpj, stateRegistration: stateRegistration)
    }
    
    static private func convertDateFromBRtoEN(stringDate: String) -> String {
        var date: String
        if let range = stringDate.range(of: "Data de Emissão: ") {
            var _date = stringDate[range.upperBound...]
            _date = _date.replacingOccurrences(of: "/", with: "-").replacingOccurrences(of: " ", with: "T") + ".000Z"
            if let _range = _date.range(of: "T") {
                let hour = _date[_range.upperBound...] //hh:mm:ss.SSSZ
                let udate = _date[..._range.lowerBound].replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "T", with: "")  //ddmmyyyy
                let unDayIndex = udate.index(udate.endIndex, offsetBy: -6)
                let unDay = udate.substring(from: unDayIndex) //mmyyyy
                let yearIndex = udate.index(udate.endIndex, offsetBy: -4)
                let year = udate.substring(from: yearIndex) //yyyy
                let dayIndex = udate.index(udate.startIndex, offsetBy: 2)
                let day = udate.substring(to: dayIndex) //dd
                let monthIndex = unDay.index(unDay.startIndex, offsetBy: 2)
                let month = unDay.substring(to: monthIndex)
                date = year + "-" + month + "-" + day + "T" + hour
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
        return date
    }
    
}


