//
//  ViewController.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit
import Alamofire

class MainView: UIViewController {
    lazy var data:[Game] = []
    lazy var selectedID:Int = 0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getData()
        giveDelegateToTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameDetailView
        vc.gameID = selectedID
    }

}

extension MainView {
    func getData()  {
        AF.request(Constants.shared.requestURL, method: .get, parameters: nil, headers: HTTPHeaders.init(Constants.shared.requestHeaders), interceptor: nil, requestModifier: nil).response { (response) in
            if let data = response.data {
                do {
                    self.data = try JSONDecoder.init().decode(Games.self, from: data).results
                    self.tableView.reloadData()
                }catch {
                    print(error)
                    print(error.localizedDescription)
                }
                
            }
        }
    }
}


extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.gameCellProperty) as! GameCell
        cell.configure(data[indexPath.row + 3])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameCell
        self.selectedID = cell.id
        performSegue(withIdentifier: Constants.shared.toGameDetail, sender: self)
    }
    
    func giveDelegateToTableView() {
        tableView.register(UINib.init(nibName: Constants.shared.gameCellProperty, bundle: nil), forCellReuseIdentifier: Constants.shared.gameCellProperty)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 100
        
        scrollView.delegate = self
    }
    
}


extension MainView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView,!scrollView.contentOffset.equalTo(CGPoint.init(x: 0, y: 0)) {
            self.tableView.isScrollEnabled = true
            self.scrollView.isScrollEnabled = false
        } else if scrollView == tableView, scrollView.contentOffset.equalTo(CGPoint.init(x: 0, y: 0)) {
            self.tableView.isScrollEnabled = false
            self.scrollView.isScrollEnabled = true
        }
    }
}

