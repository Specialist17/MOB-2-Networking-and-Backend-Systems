
import Foundation
import PlaygroundSupport


struct Listing {
    let name: String!
    
    init(name: String) {

        self.name = name
    }
}

extension Listing: Decodable {


    enum ResultKeys: String, CodingKey {
        case listing
    }
    
    enum ListingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {

        
        let resultContainer = try decoder.container(keyedBy: ResultKeys.self)

        let container = try resultContainer.nestedContainer(keyedBy: ListingKeys.self, forKey: .listing)
        
        let name = try container.decode(String.self, forKey: .name)
        
        self.init(name: name)
    }
}

struct ListingList: Decodable {
    let search_results: [Listing]
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

    func getAnime(id: String, completion: @escaping ([Listing]) -> Void) {
        
        let request = URLRequest(url: baseURL)
        
        session.dataTask(with: request) { (data, resp, err) in
            if let data = data {
                
                let animeList = try? JSONDecoder().decode(ListingList.self, from: data)
                
                guard let animes = animeList?.search_results else {return}
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

