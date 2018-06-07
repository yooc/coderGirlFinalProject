import Foundation

class RestaurantDataFetcher {
    private let location = Location()
    
    func buildURL() -> String {
        let baseURL = "https://developers.zomato.com/api/v2.1"
        let lat = location.lastLocation?.coordinate.latitude
        let long = location.lastLocation?.coordinate.longitude
        
        return baseURL + "/search?q=&lat=\(lat)&lon=\(long)"
    }
    
    func fetchRestaurant(restaurant: Restaurant, completion: @escaping (String) -> () ) {
        var request = URLRequest(url: URL(string: buildURL())!)
        request.addValue(Bundle.main.object(forInfoDictionaryKey: "ZomatoAPIKey") as! String, forHTTPHeaderField: "user-key" )
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, urlResponse, error) in
            guard let data = data else {
                print("No data")
                DispatchQueue.main.async {
                    completion("")
                }
                return
            }
            
            do {
              let jsonDecoderRestaurant = try JSONDecoder().decode(Restaurant.self, from: data)
                print(jsonDecoderRestaurant)
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
}
