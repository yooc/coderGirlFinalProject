import UIKit

class RestaurantDetailsViewController: UIViewController {

    @IBOutlet weak var detailsLabel: UILabel!
    
    var dataModel: RestaurantModel? = nil
    var restaurantSelected: Restaurant? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsLabel.text = """
        \(restaurantSelected?.cuisines ?? "Data Unavailable")
        User Rating: \(restaurantSelected?.user_rating.aggregate_rating ?? "Data Unavailable") from \(restaurantSelected?.user_rating.votes ?? "Data Unavailable") votes
        Average Cost for 2: \(restaurantSelected?.average_cost_for_two ?? 0)
        \(restaurantSelected?.location.address ?? "Data Unavailable")
        """
    }
}
