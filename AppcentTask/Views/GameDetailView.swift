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
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
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
        getData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        if let game = game {
            CoreDataController.run.saveGame(game.id, game.name, game.released, game.background_image, game.rating, game.rating_top) { (result, err) in
                if let err = err {
                    print(err.localizedDescription)
                    //show fail
                    return
                }
                
                //showSuccess
                print("Kayıt oldu")
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
}
