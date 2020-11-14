//
//  GameDetailView.swift
//  AppcentTask
//
//  Created by Said Çankıran on 14.11.2020.
//

import UIKit
import Alamofire; import Kingfisher
class GameDetailView: UIViewController {
    lazy var gameID:Int? = nil
    lazy var game:GameDetail? = nil
    var isFavorited:Bool = false
    @IBOutlet weak var gameImage: UIImageView!
    var favoriteButton:UIButton = UIButton()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var relasedDateLabel: UILabel!
    @IBOutlet weak var metaCriticLabel: UILabel!
    @IBOutlet weak var descriptionTextArea: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        descriptionTextArea.delegate = self
        descriptionTextArea.isScrollEnabled = false
        isFavorited = CoreDataController.run.checkCoreData(gameID!)
        createButton()
        getData()
        
        // Do any additional setup after loading the view.
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
    
    
    func getData() {
        AF.request(Constants.shared.requestURL + "/\(gameID ?? 0)", method: .get, parameters: nil, headers: HTTPHeaders.init(Constants.shared.requestHeaders), interceptor: nil, requestModifier: nil).response { (response) in
            if let data = response.data {
                do {
                    self.game = try JSONDecoder.init().decode(GameDetail.self, from: data)
                    self.configure()
                }catch {
                    print(error)
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func configure(){
        if let game = game {
            gameImage.kf.setImage(with: URL(string: game.background_image))
            nameLabel.text = game.name
            relasedDateLabel.text = "Released Date: \(game.released)"
            metaCriticLabel.text = "Metacritic: \(game.metacritic ?? 0)"
            descriptionTextArea.text = game.gameDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        }
    }
    

}

extension GameDetailView: UIScrollViewDelegate, UITextViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView,!scrollView.contentOffset.equalTo(CGPoint.init(x: 0, y: 0)) {
            self.descriptionTextArea.isScrollEnabled = true
            self.scrollView.isScrollEnabled = false
        } else if scrollView == descriptionTextArea, scrollView.contentOffset.equalTo(CGPoint.init(x: 0, y: 0)) {
            self.descriptionTextArea.isScrollEnabled = false
            self.scrollView.isScrollEnabled = true
        }
    }
    
    func createButton() {
        favoriteButton = UIButton.init(frame: CGRect.init(x: self.gameImage.bounds.maxX - 75, y: self.gameImage.bounds.maxY - 75, width: 50, height: 50))
        if isFavorited {
            favoriteButton.setImage(UIImage.init(named: "heart_filled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage.init(named: "heart"), for: .normal)
        }
        favoriteButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        favoriteButton.isUserInteractionEnabled = true
        gameImage.isUserInteractionEnabled = true
        gameImage.addSubview(favoriteButton)
    }
}
