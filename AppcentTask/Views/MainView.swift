//
//  ViewController.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit

class MainView: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}


extension MainView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.gameCollectionCellProperty, for: indexPath) as! GameCollectionCell
        
        cell.configure()
        
        return cell
    }
    
    func giveDelegateToTableView() {
        collectionView.register(UINib.init(nibName: Constants.shared.gameCollectionCellProperty, bundle: nil), forCellWithReuseIdentifier: Constants.shared.gameCollectionCellProperty)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

