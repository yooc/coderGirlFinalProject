import UIKit

class MyListViewController: UIViewController {

    @IBOutlet weak var myListTableView: UITableView!
    
    var dataModel: RestaurantModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myListTableView.delegate = self
        myListTableView.dataSource = self
    }
}

extension MyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.persistedList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell"), let restaurant = dataModel?.persistedList[indexPath.row] else { return UITableViewCell() }
//        guard let restaurant = dataModel?.persistedList.element(at: indexPath.row)?
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = """
        \(dataModel?.searchResults[indexPath.row].cuisines)
        User Rating: \(dataModel?.searchResults[indexPath.row].user_rating.aggregate_rating) from \(dataModel?.searchResults[indexPath.row].user_rating.votes) votes
        Average Cost for 2: \(dataModel?.searchResults[indexPath.row].average_cost_for_two)
        \(dataModel?.searchResults[indexPath.row].location.address)
        """
        return cell
    }
}

extension MyListViewController: UITableViewDelegate {
    
}
