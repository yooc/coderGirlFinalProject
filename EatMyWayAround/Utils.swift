import Foundation

class Utils {
    static func convert(json: JSON) -> [Restaurant] {
        guard let arrayOfRestaurants = json["restaurantList"] as? [JSON] else {
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
}
