//
//  GameCollectionCell.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit

class GameCollectionCell: UICollectionViewCell {
    lazy var id:Int = 0
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
        
    }
    
    override func prepareForReuse() {
        gameImage.image = UIImage.init()
        gameName.text = ""
        ratingLabel.text = ""
    }
}
