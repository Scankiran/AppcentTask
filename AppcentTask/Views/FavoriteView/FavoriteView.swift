//
//  FavoriteView.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit
import CoreData
class FavoriteView: UIViewController {
    var favoritedGames:[NSManagedObject] = []
    lazy var selectedID:Int = 0
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giveDelegateToTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameDetailView
        vc.gameID = selectedID
    }
    
    func getData() {
        CoreDataController.run.getGames { (result, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.favoritedGames = result!
            self.tableView.reloadData()
        }
    }

}


extension FavoriteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.gameCellProperty) as! GameCell
        cell.configure(favoritedGames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameCell
        self.selectedID = cell.id
        performSegue(withIdentifier: Constants.shared.toGameDetail, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let game = tableView.cellForRow(at: indexPath) as! GameCell
            _ = CoreDataController.run.deleteGame(game.id)
            self.getData()
            
        }
    }
    
    func giveDelegateToTableView() {
        tableView.register(UINib.init(nibName: Constants.shared.gameCellProperty, bundle: nil), forCellReuseIdentifier: Constants.shared.gameCellProperty)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 100
    }
    
}




