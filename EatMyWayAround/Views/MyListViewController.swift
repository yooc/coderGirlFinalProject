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
        if let detailViewController = segue.destination as? RestaurantDetailsViewController {
            detailViewController.dataModel = dataModel
            
            if let indexPath = self.myListTableView.indexPathForSelectedRow {
                detailViewController.restaurantSelected = self.dataModel?.persistedList[indexPath.row]
            }
        }
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
}

extension MyListViewController: DataAvailableDelegate {
    func dataAvailable() {
        myListTableView.reloadData()
    }
}
