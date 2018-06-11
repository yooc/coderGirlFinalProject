import Foundation

protocol DataAvailableDelegate: class {
    func dataAvailable()
}

final class SearchModel {
    private let dataFetcher: RestaurantDataFetcher
    weak var dataAvailableDelegate: DataAvailableDelegate?
    
    let json = ""
    
    init() {
        dataFetcher = RestaurantDataFetcher()
        dataFetcher.fetchRestaurant() { [weak self] (details) in
            self?.dataAvailableDelegate?.dataAvailable()
        }
    }
}
