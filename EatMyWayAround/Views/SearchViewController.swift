import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
//    let dataModel: SearchModel
    let dataModel = SearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.dataAvailableDelegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchBar.delegate = self
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell") else { return UITableViewCell() }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UISearchBarDelegate {
    
}

extension SearchViewController: DataAvailableDelegate {
    func dataAvailable() {
        
    }
}
