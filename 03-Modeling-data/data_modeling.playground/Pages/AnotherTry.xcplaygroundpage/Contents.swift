//: [Previous](@previous)

import Foundation
import PlaygroundSupport

var str = "Hello, playground"

let session = URLSession.shared

enum Methods: String {
    case get
    case post
    case put
    case delete
}

let postMethod: String! = Methods.post.rawValue
let getMethod: String! = Methods.get.rawValue
let putMethod: String! = Methods.put.rawValue
let deleteMethod: String! = Methods.delete.rawValue

// 2
let pokeUrl = URL(string: "http://pokeapi.co/api/v1/pokemon/1")!
var pokeReq = URLRequest(url: pokeUrl)

pokeReq.httpMethod = getMethod

session.dataTask(with: pokeReq) { (data, res, err) in
    if let data = data {
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        print(json ?? "hola")
    }
}.resume()

PlaygroundPage.current.needsIndefiniteExecution = true
