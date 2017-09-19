
import Foundation
import PlaygroundSupport


struct Listing {
    var name: String!
    var bedrooms: Int!
    var listings = [Listing]()
    var hostFirstName: String!
    var isSuperHost: Bool!
    
    init(name: String, bedrooms: Int, hostFirstName: String, isSuperHost: Bool) {
        self.name = name
        self.bedrooms = bedrooms
        self.hostFirstName = hostFirstName
        self.isSuperHost = isSuperHost
    }
}

extension Listing: Decodable {
    
    // Main container - "search_results: []"
    enum SearchResultKeys: String, CodingKey {
        case search_results
        
        // Second container - { listing: listing_properties,
        //                      pricing_quote: values}
        enum ResultKeys: String, CodingKey {
            case listing
            
            // Inside the listing container - "listing" : values
            enum ListingKeys: String, CodingKey {
                case name
                case bedrooms
                case host = "primary_host"
                
                enum HostKeys: String, CodingKey {
                    case hostFirstName = "first_name"
                    case isSuperhost = "is_superhost"
                }
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        
        // Go into main container
        var searchContainer = try decoder.container(keyedBy: SearchResultKeys.self)
       
        // Get the array of unkeyed listings container
        var listingsContainer = try searchContainer.nestedUnkeyedContainer(forKey: .search_results)
        print(listingsContainer.count)
    
        // loop through every listing element
        while !listingsContainer.isAtEnd {
            
            // access the current result container - {listing: value, pricing_quote: value}
            let resultContainer = try listingsContainer.nestedContainer(keyedBy: SearchResultKeys.ResultKeys.self)
            
            // access the current listing container - "listing": values
            let container = try resultContainer.nestedContainer(keyedBy: SearchResultKeys.ResultKeys.ListingKeys.self, forKey: .listing)

            // get specified values for the listing
            let name = try container.decode(String.self, forKey: .name)
            let bedrooms = try container.decode(Int.self, forKey: .bedrooms)
            
            let hostContainer = try container.nestedContainer(keyedBy: SearchResultKeys.ResultKeys.ListingKeys.HostKeys.self, forKey: .host)
            
            let hostName = try hostContainer.decode(String.self, forKey: .hostFirstName)
            let isSuperHost = try hostContainer.decode(Bool.self, forKey: .isSuperhost)
            
            // initialize a listing object
            let listing = Listing(name: name, bedrooms: bedrooms, hostFirstName: hostName, isSuperHost: isSuperHost)
            
            // add the listing object to the structs listings arrays
            self.listings.append(listing)
        }
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
                
                guard let animes = animeList?.listings else {return}
                completion(animeList!)
            }
        }.resume()
    }
}

let networking = Networking()
networking.getAnime(id: "1") { (res) in
    for listing in res.listings {
        print(listing.name)
        print(listing.bedrooms)
        print(listing.hostFirstName)
        print(listing.isSuperHost)
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true


