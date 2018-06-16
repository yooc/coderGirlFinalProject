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
    
    func setList() {
        let jsonData = persistence.
        
        guard let userData = jsonData?["Current Available Users"] else {
            print("Unable to get available users")
            return
        }
        
        availableUsers = userData as! [String]
    }
    
    func saveToList(restaurant: Restaurant) {
        
    }
}
