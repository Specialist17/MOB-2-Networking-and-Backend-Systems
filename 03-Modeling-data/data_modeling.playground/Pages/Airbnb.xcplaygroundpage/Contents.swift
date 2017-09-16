
import Foundation
import PlaygroundSupport

struct SearchResults: Decodable {
    
    struct Result: Decodable {
        
        struct Listing: Decodable {
            let bathrooms: Int!
            let name: String!
            let bedrooms: Int!
        }
        let listing: Listing!
    }
    enum SearchResultKeys: String, CodingKey {
        case results = "search_results"
    }
    
    let results = [Result]
    
    init(results: [Result]) {
        self.results = results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchResultKeys.self)
        
        let results = try container.decode([Result].self, forKey: .results)
        
        self.init(results: results)
    }
    
}

let session = URLSession.shared
let baseURL = URL(string: "https://api.airbnb.com/v2/search_results?api_key=915pw2pnf4h1aiguhph5gc5b2")!

let request = URLRequest(url: baseURL)

session.dataTask(with: request) { (data, resp, err) in
    //    print(data.result.value)
    if let data = data {
        
        let decoder = JSONDecoder()
        guard let pokemon = try? decoder.decode(SearchResults.self, from: data)
            else {return}
        
        print(pokemon)
    }
}.resume()

PlaygroundPage.current.needsIndefiniteExecution = true

