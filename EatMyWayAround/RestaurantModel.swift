import Foundation

protocol DataAvailableDelegate: class {
    func dataAvailable()
}

protocol RestaurantModelDelegate: class {
    func dataSaved()
    func errorSaving()
    func reloadData()
}

final class RestaurantModel {
    
    private let currentUserKey = "currentUser"
    
    private let location = Location()
    private let persistence = Persistence()
    private let settingsDefaults = SettingDefaults()
    
    private(set) var currentUser: String
    var searchResults = [Restaurant]()
    
    var lastRequestToSave: DispatchWorkItem?
    
    weak var restaurantModelDelegate: RestaurantModelDelegate?
        
    private let dataFetcher: RestaurantDataFetcher
    weak var dataAvailableDelegate: DataAvailableDelegate?

    init() {
        currentUser =  settingsDefaults.valueFor(key: currentUserKey) ?? ""
        dataFetcher = RestaurantDataFetcher()
        dataFetcher.fetchRestaurant(location: location) { [weak self] (restaurants) in
            for restaurant in restaurants {
                self?.searchResults.append(restaurant)
            }
            
            self?.dataAvailableDelegate?.dataAvailable()
        }
    }
    
    func saveToList(restaurant: Restaurant) {
        lastRequestToSave?.cancel()
        
        let saveChangesWorkItem = DispatchWorkItem { [weak self] in
            do {
                let restaurantJSON = try JSONEncoder().encode(restaurant)
                let appDataDictionary = ["restaurantList": restaurantJSON]
                guard let currentUser = self?.currentUser else { return }
                
                let result = self?.persistence.writeToUserList(appDataDictionary: appDataDictionary, user: currentUser) ?? false
                result ? self?.restaurantModelDelegate?.dataSaved() : self?.restaurantModelDelegate?.errorSaving()
                
            } catch let error as NSError {
                print (error.debugDescription)
            }
        }
        
        lastRequestToSave = saveChangesWorkItem
        let _ = saveChangesWorkItem.wait(timeout: .now() + 2)
        
        saveChangesWorkItem.perform()
    }
    
    var persistedList: [Restaurant]? {
        guard let listJSON = persistence.readUserList(for: currentUser) else {
            return []
        }
        
        guard let arrayOfRestaurants = listJSON["restaurantList"] as? [JSON] else {
            return []
        }

        let restaurants = arrayOfRestaurants.flatMap { (json) -> Restaurant? in
            guard let restaurantJSON = json["restaurantList"] as? JSON else {
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
