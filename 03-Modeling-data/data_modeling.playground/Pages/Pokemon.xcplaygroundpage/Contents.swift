//: [Previous](@previous)

import Foundation
import PlaygroundSupport

var str = "Hello, playground"

print(str)

struct Pokemon {
    let name: String!
    let pokedexId: Int!
    let hp: Int!
    

    init(title: String, pokedexId: Int, hp: Int) {
        self.name = title
        self.pokedexId = pokedexId
        self.hp = hp
    }
}

extension Pokemon: Decodable {

    // Declaring our keys
    enum Keys: String, CodingKey {
        case name
        case pokedexId = "pkdx_id"
        case hp
    }

    init(from decoder: Decoder) throws {
        // define our keyed container
        let container = try decoder.container(keyedBy: Keys.self)

        let name: String = try container.decode(String.self, forKey: .name) // extracting the data
        let pokedexId: Int = try container.decode(Int.self, forKey: .pokedexId)
        let hp: Int = try container.decode(Int.self, forKey: .hp)

        self.init(title: name, pokedexId: pokedexId, hp: hp)
    }
}

let session = URLSession.shared
let baseURL = URL(string: "http://pokeapi.co/api/v1/pokemon/1/")!

let request = URLRequest(url: baseURL)

session.dataTask(with: request) { (data, resp, err) in
//    print(data.result.value)
    if let data = data {
        
        guard let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
            else {return}
        
        print(pokemon.name)
    }
}.resume()

//let myStruct = try JSONDecoder().decode(Pokemon.self, from: json) // decoding our data
//print(myStruct) // decoded!



//enum NetworkError: Error {
//    case unknown
//    case couldNotParseJSON
//}
//
//enum Result<T> {
//    case success(T)
//    case failure(NetworkError)
//}
//
//class Networking {
//    let session = URLSession.shared
//    let baseURL = URL(string: "http://pokeapi.co/api/v1/pokemon/1/")!
//
//    func getPokemon(id: String, completion: @escaping (Result<Pokemon>) -> Void) {
//
//        let request = URLRequest(url: baseURL)
//
//        session.dataTask(with: request) { (data, resp, err) in
//            print(data)
//            if let data = data {
//                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Data
//                print(json)
//                guard let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data)
//                    else {return completion(Result.failure(NetworkError.couldNotParseJSON)) }
////                guard let pokemones = pokemon
////                    else {return completion(Result.failure(NetworkError.couldNotParseJSON))}
////
//                completion(Result.success(pokemon))
//                print(pokemon)
//            }
//        }.resume()
//    }
//}
//
//let result = Networking()
//result.getPokemon(id: "1") { (res) in
//    print(res)
//}

//: Playground - noun: a place where people can play
//import Foundation
//
//struct Swifter {
//    let fullName: String
//    let id: Int
//    let twitter: URL
//
//    init(fullName: String, id: Int, twitter: URL) { // default struct initializer
//        self.fullName = fullName
//        self.id = id
//        self.twitter = twitter
//    }
//}
//
//extension Swifter: Decodable {
//    enum MyStructKeys: String, CodingKey { // declaring our keys
//        case fullName = "fullName"
//        case id = "id"
//        case twitter = "twitter"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
//        let fullName: String = try container.decode(String.self, forKey: .fullName) // extracting the data
//        let id: Int = try container.decode(Int.self, forKey: .id) // extracting the data
//        let twitter: URL = try container.decode(URL.self, forKey: .twitter) // extracting the data
//
//        self.init(fullName: fullName, id: id, twitter: twitter) // initializing our struct
//    }
//}
//
//let json = """
//{
// "fullName": "Federico Zanetello",
// "id": 123456,
// "twitter": "http://twitter.com/zntfdr"
//}
//""".data(using: .utf8)! // our native (JSON) data
//let myStruct = try JSONDecoder().decode(Swifter.self, from: json) // decoding our data
//print(myStruct) // decoded!
//: [Next](@next)
PlaygroundPage.current.needsIndefiniteExecution = true
