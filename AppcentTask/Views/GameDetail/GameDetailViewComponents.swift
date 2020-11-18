//
//  GameDetailViewComponents.swift
//  AppcentTask
//
//  Created by Said Çankıran on 18.11.2020.
//

import Foundation
import UIKit

extension GameDetailView {
    func createView() {
        
        backButton1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton1)
        backButton1.setTitle("Back", for: .normal)
        backButton1.setTitleColor(UIColor.black, for: .normal)
        (isFavorited) ? self.favoriteButton.setImage(UIImage.init(named: "heart_filled"), for: .normal):self.favoriteButton.setImage(UIImage.init(named: "heart"), for: .normal)
        backButton1.addTarget(self, action: #selector(backButton(_:)), for: .allTouchEvents)
        backButton1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        backButton1.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButton1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        gameImage1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gameImage1)
        gameImage1.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gameImage1.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gameImage1.topAnchor.constraint(equalTo: backButton1.bottomAnchor,constant: 16).isActive = true
        gameImage1.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        
        nameLabel1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameLabel1)
        nameLabel1.font = nameLabel1.font.withSize(24)
        nameLabel1.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
        nameLabel1.topAnchor.constraint(equalTo: gameImage1.bottomAnchor,constant: 8).isActive = true
        nameLabel1.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        releasedDate.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(releasedDate)
        releasedDate.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
        releasedDate.topAnchor.constraint(equalTo: nameLabel1.bottomAnchor,constant: 4).isActive = true
        releasedDate.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        metacritic.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(metacritic)
        metacritic.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
        metacritic.topAnchor.constraint(equalTo: releasedDate.bottomAnchor,constant: 4).isActive = true
        metacritic.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        gameDescription.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gameDescription)
        gameDescription.font = UIFont.systemFont(ofSize: 17)
        gameDescription.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
        gameDescription.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16).isActive = true
        gameDescription.topAnchor.constraint(equalTo: metacritic.bottomAnchor,constant: 16).isActive = true
        gameDescription.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        
        
        gameImage1.addSubview(favoriteButton)
        gameImage1.isUserInteractionEnabled = true
        if isFavorited {
            favoriteButton.setImage(UIImage.init(named: "heart_filled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage.init(named: "heart"), for: .normal)
        }
        favoriteButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.bottomAnchor.constraint(equalTo: gameImage1.bottomAnchor, constant: -16).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
