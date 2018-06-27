import Foundation

class Restaurant: Codable {
    var name: String
    var location: LocationDetails
    var cuisines: String
    var average_cost_for_two: Int
    var user_rating: Ratings
    
    init(name: String, location: LocationDetails, cuisines: String, average_cost_for_two: Int, user_rating: Ratings) {
        self.name = name
        self.location = location
        self.cuisines = cuisines
        self.average_cost_for_two = average_cost_for_two
        self.user_rating = user_rating
    }
}

class LocationDetails: Codable {
    var address: String
    
    init(address: String) {
        self.address = address
    }
}

class Ratings: Codable {
    var aggregate_rating: String
    var votes: String
    
    init(aggregate_rating: String, votes: String) {
        self.aggregate_rating = aggregate_rating
        self.votes = votes
    }
}
