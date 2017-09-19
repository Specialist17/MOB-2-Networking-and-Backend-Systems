
import Foundation
import PlaygroundSupport


struct Listing {
    var name: String!
    var bedrooms: Int!
    var listings: UnkeyedDecodingContainer?
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
        
        var searchContainer = try decoder.container(keyedBy: SearchResultKeys.self)
       
        var listingsContainer = try searchContainer.nestedUnkeyedContainer(forKey: .search_results)
        
//        let resultContainer = try listingsContainer.nestedContainer(keyedBy: SearchResultKeys.ResultKeys.self)
//
//        let listingContainer = try resultContainer.decode(String.self, forKey: .listing)
//        print(resultContainer)
//
//        print(listingContainer)
        
        self.listings = listingsContainer
        
//        for x in 0..<listingsContainer.count! {
//            print(x)
//        }

    }
}

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
    
    func getAnime(id: String, completion: @escaping (Listing) -> Void) {
        
        let request = URLRequest(url: baseURL)
        
        session.dataTask(with: request) { (data, resp, err) in
            if let data = data {
                
                let animeList = try? JSONDecoder().decode(Listing.self, from: data)
//                print(animeList)
                
//                guard let animes = animeList?.listings else {return}
                completion(animeList!)
            }
            }.resume()
    }
}

let networking = Networking()
networking.getAnime(id: "1") { (res) in
    print(res.listings)
}

PlaygroundPage.current.needsIndefiniteExecution = true


