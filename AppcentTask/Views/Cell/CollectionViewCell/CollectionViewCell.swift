//
//  CollectionViewCell.swift
//  AppcentTask
//
//  Created by Said Çankıran on 18.11.2020.
//

import UIKit
import CoreData
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    var id = 0
    let indicator = UIActivityIndicatorView.init(style: .medium)
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isUserInteractionEnabled = true
    }

    
    /// Assign Game informations to cell components
    /// - Parameter game: Game Object
    func configure(_ game:Game) {
        id = game.id
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect.init(origin: gameImage.bounds.origin, size: CGSize.init(width: 46, height: 46))
        
        self.gameImage.addSubview(indicator)
        indicator.startAnimating()
        gameImage.kf.setImage(with: URL(string: game.background_image),options: [.targetCache(customCache())]) { (image, err, cacheType, url) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.indicator.stopAnimating()
        }
        nameLabel.text = game.name
        ratingLabel.text = "\(game.rating)/\(game.rating_top)"
    }
    
    
    
    /// Assign Game informations to cell components
    /// - Parameter game: Game Object
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
    
    //For Cache to disk, not memory
    private func customCache() -> ImageCache {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 1
        return cache
    }
    
}
