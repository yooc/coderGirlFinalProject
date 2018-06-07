import UIKit

class MyListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad of MyListViewController")
        // Do any additional setup after loading the view.
    }
}

extension MyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell") else { return UITableViewCell() }
        return cell
    }
}

extension MyListViewController: UITableViewDelegate {
    
}
