//
//  FavoriteView.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit
import CoreData
class FavoriteViewController: UIViewController {
    //MARK: Variables
    var favoritedGames:[NSManagedObject] = [] {
        didSet {
            giveDelegateToView()
        }
    }
    
    lazy var collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    lazy var selectedID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    //MARK: Ger Data
    /// Get favorited games from CoreData
    func getData() {
        CoreDataController.run.getGames { (result, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.favoritedGames = result!
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameDetailViewController
        vc.gameID = selectedID
    }

}


//MARK: Collection View
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoritedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.gameCellProperty, for: indexPath) as! CollectionViewCell
        cell.configure(self.favoritedGames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        self.selectedID = cell.id
        performSegue(withIdentifier: Constants.shared.toGameDetail, sender: self)
    }

    
    func giveDelegateToView() {
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.shared.gameCellProperty)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}






