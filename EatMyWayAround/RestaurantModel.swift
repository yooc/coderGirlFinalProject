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
    var persistedList: [Restaurant?] = []
    
    private let location = Location()
    private let persistence = Persistence()
    private let settingsDefaults = SettingDefaults()
    
    var searchResults = [Restaurant]()
    
    var lastRequestToSave: DispatchWorkItem?
    
    weak var restaurantModelDelegate: RestaurantModelDelegate?
    
    private let dataFetcher: RestaurantDataFetcher
    weak var dataAvailableDelegate: DataAvailableDelegate?
    
    init() {
        dataFetcher = RestaurantDataFetcher()
        dataFetcher.fetchRestaurant(location: location) { [weak self] (restaurants) in
            for restaurant in restaurants {
                self?.searchResults.append(restaurant)
            }
            
            self?.dataAvailableDelegate?.dataAvailable()
        }
    }
    
    func getPersistedList(user: String) -> [Restaurant?] {
        guard let listData = persistence.readUserList(for: currentUser) else { return [] }
        
        guard let json1 = try? JSONSerialization.jsonObject(with: listData, options: .allowFragments), let json2 = json1 as? JSON else {
            print("JSON serialization failed")
            return []
        }
        
        let restaurants = Utils.convert(json: json2)
        return restaurants
    }
    
    func setPersistedList(list: [Restaurant?]) {
        persistedList = list
    }
    
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
                
                self?.setPersistedList(list: currentList)
                
            } catch let error as NSError {
                print (error.debugDescription)
            }
        }
        
        lastRequestToSave = saveChangesWorkItem
        let _ = saveChangesWorkItem.wait(timeout: .now() + 2)
        
        saveChangesWorkItem.perform()
    }
}
