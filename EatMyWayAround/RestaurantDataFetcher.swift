import Foundation

typealias JSON = [String : Any]

class RestaurantDataFetcher {
    
    func convert(json: JSON) -> [Restaurant] {
        guard let arrayOfRestaurants = json["restaurants"] as? [JSON] else {
            return []
        }
        
        let restaurants = arrayOfRestaurants.flatMap { (json) -> Restaurant? in
            guard let restaurantJSON = json["restaurant"] as? JSON else {
                return nil
            }
            
            do {
                let restaurantData = try JSONSerialization.data(withJSONObject: restaurantJSON, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                let restaurant = try JSONDecoder().decode(Restaurant.self, from: restaurantData)
                return restaurant
            } catch let error as NSError {
                print(error.debugDescription)
                return nil
            }
        }
        return restaurants
    }
    
    func fetchRestaurant(location: Location, completion: @escaping ([Restaurant]) -> () ) {
        let lat = location.lastLocation?.coordinate.latitude
        let long = location.lastLocation?.coordinate.longitude
        
        let baseURL = "https://developers.zomato.com/api/v2.1"
        let requestURL = baseURL + "/search?q=&lat=\(lat)&lon=\(long)"
        
        var request = URLRequest(url: URL(string: requestURL)!)
        request.addValue(Bundle.main.object(forInfoDictionaryKey: "ZomatoAPIKey") as! String, forHTTPHeaderField: "user-key" )
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, urlResponse, error) in
            guard let data = data else {
                print("No data")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let json1 = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) , let json2 = json1 as? JSON else {
                print("JSON serialization failed")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            let restaurants = self.convert(json: json2)
            DispatchQueue.main.async {
                completion(restaurants)
            }
            return
        }
        task.resume()
    }
}
