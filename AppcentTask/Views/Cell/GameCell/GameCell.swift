//
//  GameCell.swift
//  AppcentTask
//
//  Created by Said Çankıran on 14.11.2020.
//

import UIKit
import Kingfisher
import CoreData

class GameCell: UITableViewCell {
    lazy var id:Int = 0
    let cache = ImageCache.default
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
        gameImage.kf.setImage(with: URL(string: game.background_image),options: [.targetCache(customCache())])
        nameLabel.text = game.name
        ratingLabel.text = "\(game.rating)/\(game.rating_top)"
    }
    
    func configure(_ game:NSManagedObject) {
        let id = game.value(forKey: "id") as! Int
        let name = game.value(forKey: "name") as! String
        let url = game.value(forKey: "background_image") as! String
        let rating = game.value(forKey: "rating") as! Double
        let rating_top = game.value(forKey: "rating_top") as! Double
        
        self.id = id
        gameImage.kf.setImage(with: URL(string: url),options: [.targetCache(customCache())])
        nameLabel.text = name
        ratingLabel.text = "\(rating)/\(rating_top)"
    }
    
    override func prepareForReuse() {
        gameImage.image = nil
        nameLabel.text = ""
        ratingLabel.text = ""
    }
    
    private func customCache() -> ImageCache {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 1
        return cache
    }
}
