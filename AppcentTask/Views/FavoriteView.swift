//
//  FavoriteView.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit

class FavoriteView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()   
    }

}


extension FavoriteView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.gameCollectionCellProperty, for: indexPath) as! GameCollectionCell
        
        //cell.configure()
        
        return UICollectionViewCell()
    }
    
    func giveDelegateToTableView() {
        collectionView.register(UINib.init(nibName: Constants.shared.gameCellProperty, bundle: nil), forCellWithReuseIdentifier: Constants.shared.gameCellProperty)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}




