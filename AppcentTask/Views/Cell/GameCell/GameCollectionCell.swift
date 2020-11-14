//
//  GameCollectionCell.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit
import Kingfisher
class GameCollectionCell: UICollectionViewCell {
    lazy var id:Int = 0
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ data:Game) {
        gameName.text = data.name
        ratingLabel.text = "\(data.rating)/\(data.rating_top)"
        gameImage.kf.setImage(with: URL(string: data.background_image))
        
    }
    
    override func prepareForReuse() {
        gameImage.image = UIImage.init()
        gameName.text = ""
        ratingLabel.text = ""
    }
}
