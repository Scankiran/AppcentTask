//
//  MainViewComponents.swift
//  AppcentTask
//
//  Created by Said Çankıran on 18.11.2020.
//

import Foundation
import UIKit

extension MainView {
    //MARK: Show Not Found
    func showNotFound() {
        pageControl.removeFromSuperview()
        carouselView.removeFromSuperview()
        collectionView.removeFromSuperview()
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Üzgünüz, aradığınız oyun bulunamadı!"
        
        view.tag = 9
        view.backgroundColor = UIColor.white
        
        view.addSubview(label)
        self.view.addSubview(view)
        
        view.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.view.frame.height - 80).isActive = true
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        label.textAlignment = .center
  
    }
    
    func createCarousel() {
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(carouselView)
        carouselView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
        carouselView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        carouselView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        carouselView.heightAnchor.constraint(equalToConstant: 198).isActive = true
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.isUserInteractionEnabled = false
        contentView.addSubview(pageControl)
        pageControl.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 16).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor,constant: 0).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 123).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    

    
    func createCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 320, height: 100)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor.clear
        contentView.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -8).isActive = true
        collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16).isActive = true
    }
}


extension MainView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView,!scrollView.contentOffset.equalTo(CGPoint.init(x: 0, y: 0)) {
            self.collectionView.isScrollEnabled = true
            self.scrollView.isScrollEnabled = false
        } else if scrollView == collectionView, scrollView.contentOffset.equalTo(CGPoint.init(x: 0, y: 0)) {
            self.collectionView.isScrollEnabled = false
            self.scrollView.isScrollEnabled = true
        }
    }
    
    func giveDelegateToTableView() {
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.shared.gameCellProperty)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        scrollView.delegate = self
    }
    
    //MARK:Search Bar Functions
        @objc func dismissKeyboard() {
            print("dismiswork")
          searchBar.resignFirstResponder()
        }

        
}
