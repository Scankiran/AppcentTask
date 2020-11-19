//
//  GameDetailView.swift
//  AppcentTask
//
//  Created by Said Çankıran on 14.11.2020.
//

import UIKit
import Alamofire; import Kingfisher
class GameDetailViewController: UIViewController {
    
    //MARK: Variables
    lazy var backButton1 = UIButton()
    lazy var gameImage1 = UIImageView()
    lazy var nameLabel1 = UILabel()
    lazy var releasedDate = UILabel()
    lazy var metacritic = UILabel()
    lazy var gameDescription = UITextView()
    lazy var favoriteButton:UIButton = UIButton()
    
    
    lazy var gameID:Int? = nil
    lazy var game:GameDetail? = nil
    var isFavorited:Bool = false
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        isFavorited = CoreDataController.run.checkCoreData(gameID!)
        getData()
        createView()
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addFavorite() {
        if let game = game {
            if !isFavorited {
                CoreDataController.run.saveGame(game.id, game.name, game.released, game.background_image, game.rating, game.rating_top) { (result, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        //show fail
                        return
                    }
                    
                    //showSuccess
                    print("Kayıt oldu")
                    self.favoriteButton.setImage(UIImage.init(named: "heart_filled"), for: .normal)
                    self.isFavorited = true
                }
            } else {
                if CoreDataController.run.deleteGame(gameID!) {
                    print("deleted")
                    //showSucces
                    self.favoriteButton.setImage(UIImage.init(named: "heart"), for: .normal)
                    self.isFavorited = false
                } else {
                    //show fail.
                }
            }
            
        }
       
    }
    
    
    //MARK: Get Data
    /// Fetch Selected GameDetail from API with Alamofire. And If fectch after first page, append data to situated data
    func getData() {
        API.run.getGameDetail(gameID: self.gameID ?? 0) { (gameDetail, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.game = gameDetail!
            self.configure()
        }
    }
    
    //MARK: Configure
    ///Assign informations to view.
    func configure(){
        if let game = game {
            gameImage1.kf.setImage(with: URL(string: game.background_image))
            nameLabel1.text = game.name
            releasedDate.text = "Released Date: \(game.released)"
            metacritic.text = "Metacritic: \(game.metacritic ?? 0)"
            gameDescription.text = game.gameDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
    }

}

