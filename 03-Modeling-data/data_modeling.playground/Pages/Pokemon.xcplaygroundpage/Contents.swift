//: [Previous](@previous)

import Foundation
import PlaygroundSupport

var str = "Hello, playground"

print(str)



struct Pokemon {
    let name: String!
    let baseExperience: Int!
    
    struct Species: Codable {
        let speciesName: String
        
        enum SpeciesKeys: String, CodingKey {
            case speciesName = "name"
        }
    
    }
    
    struct TypeObj: Decodable {
        let slot: Int!
        
        struct PokeType: Codable {
            let name: String!
            
            enum PokeKeys: String, CodingKey {
                case name
            }
        }
        
        let type: PokeType
        
        init(slot: Int, type: PokeType) {
            self.slot = slot
            self.type = type
        }
        
        enum Keys: String, CodingKey {
            case slot
            case type
        }
        
        init(from decoder: Decoder) throws {
            // define our keyed container
            let container = try decoder.container(keyedBy: Keys.self)
            
            let slot: Int = try container.decode(Int.self, forKey: .slot)
            let typeContainer = try container.nestedContainer(keyedBy: PokeType.PokeKeys.self, forKey: .type)
            let pokeType = try typeContainer.decode(String.self, forKey: .name)
            
            let type = PokeType(name: pokeType)
            
            self.init(slot: slot, type: type)
        }
    }
    
    let types: [TypeObj]!
    let species: Species!
    

    init(title: String, baseExperience: Int, types: [TypeObj], species: Species) {
        self.name = title
        self.baseExperience = baseExperience
        self.types = types
        self.species = species
    }
}

extension Pokemon: Decodable {

    // Declaring our keys
    enum Keys: String, CodingKey {
        case name
        case baseExperience = "base_experience"
        case types
        case species
    }

    init(from decoder: Decoder) throws {
        // define our keyed container
        let container = try decoder.container(keyedBy: Keys.self)

        let name: String = try container.decode(String.self, forKey: .name) // extracting the data
        let baseExperience: Int = try container.decode(Int.self, forKey: .baseExperience)
        let types: [TypeObj] = try container.decode([TypeObj].self, forKey: .types)
        let speciesKey = try container.nestedContainer(keyedBy: Species.SpeciesKeys.self, forKey: .species)
        let speciesName = try speciesKey.decode(String.self, forKey: .speciesName)
        
        let species = Species(speciesName: speciesName)

        self.init(title: name, baseExperience: baseExperience, types: types, species: species)
    }
}

let session = URLSession.shared
let baseURL = URL(string: "http://pokeapi.co/api/v2/pokemon/1/")!

let request = URLRequest(url: baseURL)

session.dataTask(with: request) { (data, resp, err) in
//    print(data.result.value)
    if let data = data {
        
        let decoder = JSONDecoder()
        guard let pokemon = try? decoder.decode(Pokemon.self, from: data)
            else {return}
        
        print(pokemon)
    }
}.resume()

PlaygroundPage.current.needsIndefiniteExecution = true
