//
//  ViewController.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit
import Alamofire
import iCarousel
class MainViewController: UIViewController {
    //MARK: Variables
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var pageControl: UIPageControl = UIPageControl()
    var collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var carouselView: iCarousel = iCarousel()
    
    lazy var isSearch:Bool = false
    lazy var searchResult:[Game] = []
    lazy var selectedID:Int = 0
    
    var data:Games? {
        didSet {
            carouselView.delegate = self
            carouselView.dataSource = self
            // For autoscrool for every 5 second.
            _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoScrool), userInfo: nil, repeats: true)
        }
    }
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createCarousel()
        createCollectionView(topAnchorTarget: pageControl)
        searchBar.delegate = self
        getData(appendData: false)
        giveDelegateToView()
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameDetailViewController
        vc.gameID = selectedID
    }

    var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
      return recognizer
    }()
}





//MARK: Get Data
extension MainViewController {
    ////Fetch Games from API with Alamofire. And If fectch after first page, append data to situated data.
    func getData(appendData:Bool) {
        API.run.getGames { (games, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if appendData {
                self.data!.results.append(contentsOf: games!.results)
                self.data!.previous = games!.previous
                self.data!.next = games!.next
            } else {
                self.data = games!
            }
            
            self.collectionView.reloadData()
        }
    }
}






//MARK: Carousel View.
extension MainViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 3
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView.init()
        imageView.frame = CGRect.init(x: 0, y: 10, width: carouselView.frame.width - 20, height: carouselView.frame.height)
        imageView.kf.setImage(with: URL(string: self.data!.results[index].background_image))
        
        return imageView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.2
        }
        
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        self.selectedID = self.data!.results[index].id
        performSegue(withIdentifier: Constants.shared.toGameDetail, sender: self)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    
    /// Auto scrool between top Games on Carousel view.
    @objc private func autoScrool() {
        if carouselView.currentItemIndex != carouselView.numberOfItems {
            carouselView.scrollToItem(at: carouselView.currentItemIndex + 1, duration: 1)
        } else {
            carouselView.scrollToItem(at: 0, duration: 1)
        }
    }
    
}






// MARK: - Search Bar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        searchResult.removeAll()
        searchBar.endEditing(true)
        
        if self.view.subviews.last?.tag == 9 {
            self.view.subviews.last?.removeFromSuperview()
        }
        
        createCarousel()
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = false
        collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8).isActive = true
        self.collectionView.reloadData()
    }
    
  
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
        view.addGestureRecognizer(tapRecognizer)
    }
  
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearch = false
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    //MARK: Search Text Change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            
            searchResult.removeAll()
            isSearch = true
            
            for game in data!.results {
                if game.name.contains(searchText) {
                    searchResult.append(game)
                }
            }
            
            //Misstype or other mistake
            if !searchResult.isEmpty, self.view.subviews.last?.tag == 9 {
                self.view.subviews.last?.removeFromSuperview()
                createCollectionView(topAnchorTarget: self.searchBar)
                collectionView.reloadData()
                return
            }
            
            if searchResult.isEmpty {
                showNotFound()
                return
            }
            
            //If carousel on view, remove.
            if carouselView.isDescendant(of: self.contentView) {
                carouselView.removeFromSuperview()
                pageControl.removeFromSuperview()
                self.collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
            }
            
            self.collectionView.reloadData()
            return
        }
        
        if searchText.count == 0 {
            isSearch = false
            collectionView.removeFromSuperview()
            createCarousel()
            createCollectionView(topAnchorTarget: pageControl)
            collectionView.reloadData()
        }
 
    }

}





//MARK: Colleciton View
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (isSearch) ? searchResult.count : ((data?.results.count ?? 0) - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.gameCellProperty, for: indexPath) as! CollectionViewCell
        (isSearch) ? cell.configure(searchResult[indexPath.row]):cell.configure(data!.results[indexPath.row + 3])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        self.selectedID = cell.id
        performSegue(withIdentifier: Constants.shared.toGameDetail, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 4 == data!.results.count, !isSearch {
            getData(appendData: true)
        }
    }
}
