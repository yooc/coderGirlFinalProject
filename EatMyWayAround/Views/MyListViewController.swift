import UIKit

class MyListViewController: UIViewController {

    @IBOutlet weak var myListTableView: UITableView!
    
    var dataModel: RestaurantModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel?.dataAvailableDelegate = self
        myListTableView.delegate = self
        myListTableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? RestaurantDetailsViewController, let restaurantSelected = sender as? Restaurant {
            detailViewController.dataModel = dataModel
            detailViewController.restaurantSelected = restaurantSelected
        }
        let storyboard = UIStoryboard(name: "MyList", bundle: nil)
        let restaurantDetails = storyboard.instantiateViewController(withIdentifier: "restaurantDetails")
        restaurantDetails.modalTransitionStyle = .crossDissolve
        self.present(restaurantDetails, animated: true, completion: nil)
    }
}

extension MyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.persistedList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell") else { return UITableViewCell() }
        guard let restaurantArray = dataModel?.persistedList else { return UITableViewCell() }
        guard let restaurant = restaurantArray[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = restaurant.name
        
        return cell
    }
}

extension MyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let restaurantArray = dataModel?.persistedList else { return }
        guard let restaurant = restaurantArray[indexPath.row] else { return }
        
        performSegue(withIdentifier: "showDetail", sender: restaurant)
    }
}

extension MyListViewController: DataAvailableDelegate {
    func dataAvailable() {
        myListTableView.reloadData()
    }
}
