//
//  FavoriteViewComponents.swift
//  AppcentTask
//
//  Created by Said Çankıran on 19.11.2020.
//

import Foundation
import UIKit

extension FavoriteViewController {
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
