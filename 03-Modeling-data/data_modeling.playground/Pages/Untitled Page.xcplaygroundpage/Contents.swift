
import Foundation
import PlaygroundSupport


struct Listing {
    var name: String!
    var bedrooms: Int!
    var listings = [Listing]()

}

extension Listing: Decodable {
    
    enum SearchResultKeys: String, CodingKey {
        case search_results
        
        enum ResultKeys: String, CodingKey {
            case listing
            
            enum ListingKeys: String, CodingKey {
                case name
                case bedrooms
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        
        // container for [{ "count": 4 }, { "count": 5 }]
        var searchContainer = try decoder.container(keyedBy: SearchResultKeys.self)
       
        var listingsContainer = try searchContainer.nestedUnkeyedContainer(forKey: .search_results)
        
        if let count = listingsContainer.count {
            self.listings.reserveCapacity(count)
            print("we good, we solid")
            print(count)
        }
        
        while !listingsContainer.isAtEnd {
            
            // container for a single nested object in the array, e.g { "count": 4 }
           
            let resultContainer = try listingsContainer.nestedContainer(keyedBy: SearchResultKeys.ResultKeys.self)
            
            let container = try resultContainer.nestedContainer(keyedBy: SearchResultKeys.ResultKeys.ListingKeys.self, forKey: .listing)
            
            let name = try container.decode(String.self, forKey: .name)
            let bedrooms = try container.decode(Int.self, forKey: .bedrooms)
            
            self.listings.append(
                try resultContainer.decode(Listing.self, forKey: .listing)
            )
        }
    }
}
//
//struct ListingList: Decodable {
//    let search_results: [Listing]
//
//}

let session = URLSession.shared
let baseURL = URL(string: "https://api.airbnb.com/v2/search_results?api_key=915pw2pnf4h1aiguhph5gc5b2")!

typealias JSON = [String: Any]

//: Defining the types of errors our application can have
enum NetworkError: Error {
    case unknown
    case couldNotParseJSON
}



class Networking {
    let session = URLSession.shared
    let baseURL = URL(string: "https://api.airbnb.com/v2/search_results?api_key=915pw2pnf4h1aiguhph5gc5b2")!
    
    func getAnime(id: String, completion: @escaping ([Listing]) -> Void) {
        
        let request = URLRequest(url: baseURL)
        
        session.dataTask(with: request) { (data, resp, err) in
            if let data = data {
                
                let animeList = try? JSONDecoder().decode(Listing.self, from: data)
                
                guard let animes = animeList?.listings else {return}
                completion(animes)
            }
            }.resume()
    }
}

let networking = Networking()
networking.getAnime(id: "1") { (res) in
    dump(res)
}

PlaygroundPage.current.needsIndefiniteExecution = true


