//
//  GameCell.swift
//  AppcentTask
//
//  Created by Said Çankıran on 14.11.2020.
//

import UIKit
import Kingfisher
class GameCell: UITableViewCell {
    lazy var id:Int = 0
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(_ game:Game) {
        id = game.id
        gameImage.kf.setImage(with: URL(string: game.background_image))
        nameLabel.text = game.name
        ratingLabel.text = "\(game.rating)/\(game.rating_top)"
    }
    
    override func prepareForReuse() {
        gameImage.image = nil
        nameLabel.text = ""
        ratingLabel.text = ""
    }
    
}
