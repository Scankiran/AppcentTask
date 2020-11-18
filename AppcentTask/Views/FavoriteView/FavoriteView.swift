//
//  FavoriteView.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit
import CoreData
class FavoriteView: UIViewController {
    var favoritedGames:[NSManagedObject] = [] {
        didSet {
            giveDelegateToView()
        }
    }
    lazy var collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    lazy var selectedID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        createCollectionView()
        
        
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
            self.collectionView.reloadData()
        }
    }

}

extension FavoriteView: UICollectionViewDelegate, UICollectionViewDataSource {
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


extension FavoriteView {
    func createCollectionView() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 320, height: 100)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant:  -8).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16).isActive = true
    }
}




