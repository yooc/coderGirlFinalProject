import Foundation

protocol DataAvailableDelegate: class {
    func dataAvailable()
}

protocol RestaurantModelDelegate: class {
    func dataSaved()
    func errorSaving()
}

final class RestaurantModel {
    
    private let currentUser = "currentUser"
    
    let location = Location()
    private let persistence = Persistence()
    var searchResults = [Restaurant]()
    
    var lastRequestToSave: DispatchWorkItem?
    let dataFetcher: RestaurantDataFetcher
    weak var dataAvailableDelegate: DataAvailableDelegate?
    weak var restaurantModelDelegate: RestaurantModelDelegate?
    
    init() {
        dataFetcher = RestaurantDataFetcher()
    }
    
    /// Method which performs API query and populates searchResults 
    func populateSearchResults() {
        self.clearSearchResults()
        dataFetcher.fetchRestaurant(location: location) { [weak self] (restaurants) in
            for restaurant in restaurants {
                self?.searchResults.append(restaurant)
            }
            self?.dataAvailableDelegate?.dataAvailable()
        }
    }
    
    /// Method which fetches the user's persisted list from local file
    ///
    /// - Parameter user: Key for user
    /// - Returns: User's persisted list as an array of Restaurants
    func getPersistedList(user: String) -> [Restaurant?] {
        guard let listJSON = persistence.readUserList(for: currentUser) else {
            return []
        }
        
        guard let arrayOfRestaurants = listJSON["restaurantList"] as? [JSON] else {
            return []
        }
        
        let restaurants = arrayOfRestaurants.compactMap { (json) -> Restaurant? in
            
            guard let restaurantJSON = json as? JSON else { return nil }
            
            do {
                let restaurantData = try JSONSerialization.data(withJSONObject: restaurantJSON, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                let restaurant = try JSONDecoder().decode(Restaurant.self, from: restaurantData)
                return restaurant
            } catch let error as NSError {
                print("getPersistedList error: ", error.debugDescription)
                return nil
            }
        }
        return restaurants
    }
    
    /// Method which writes the user's updated list to local file
    ///
    /// - Parameter restaurant: Restaurant object to save
    func saveToList(restaurant: Restaurant) {
        lastRequestToSave?.cancel()
        
        let saveChangesWorkItem = DispatchWorkItem { [weak self] in
            do {
                var currentList = self?.getPersistedList(user: (self?.currentUser)!) ?? []
                currentList.append(restaurant)
                
                let appDataDictionary = ["restaurantList": currentList]
                
                let restaurantData = try JSONEncoder().encode(appDataDictionary)
                
                guard let currentUser = self?.currentUser else { return }
                
                let result = self?.persistence.writeToUserList(appData: restaurantData, user: currentUser) ?? false
                result ? self?.restaurantModelDelegate?.dataSaved() : self?.restaurantModelDelegate?.errorSaving()
                
            } catch let error as NSError {
                print ("saveToList error: ", error.debugDescription)
            }
        }
        
        lastRequestToSave = saveChangesWorkItem
        let _ = saveChangesWorkItem.wait(timeout: .now() + 2)
        
        saveChangesWorkItem.perform()
    }
    
    /// Reset searchResults array to empty array to prepare for next query
    func clearSearchResults() {
        searchResults = [Restaurant]()
    }
    
    var persistedList: [Restaurant?] {
        return getPersistedList(user: currentUser)
    }
}
