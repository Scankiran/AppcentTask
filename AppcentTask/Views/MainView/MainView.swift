//
//  ViewController.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import UIKit
import Alamofire
import iCarousel
class MainView: UIViewController {
    
 
    @IBOutlet weak var searchBar: UISearchBar!
    var pageControl: UIPageControl = UIPageControl()
    var tableView: UITableView = UITableView()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var carouselView: iCarousel = iCarousel()
    
    lazy var isSearch:Bool = false
    lazy var searchResult:[Game] = []
    lazy var selectedID:Int = 0
    var data:Games? {
        didSet {
            carouselView.delegate = self
            carouselView.dataSource = self
            _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoScrool), userInfo: nil, repeats: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createCarousel()
        createTableView()
        searchBar.delegate = self
        getData()
        giveDelegateToTableView()
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameDetailView
        vc.gameID = selectedID
    }

    var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
      return recognizer
    }()
}

//MARK: Carousel View.
extension MainView: iCarouselDelegate, iCarouselDataSource {
    
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
        if option == .wrap {
            return 1
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
    
    
    @objc func autoScrool() {
        if carouselView.currentItemIndex != carouselView.numberOfItems {
            carouselView.scrollToItem(at: carouselView.currentItemIndex + 1, duration: 1)
        } else {
            carouselView.scrollToItem(at: 0, duration: 1)
        }
    }
    
}

// MARK: - Search Bar Delegate
extension MainView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    
        //If search bar text not empty, do search
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
            }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        searchResult.removeAll()
        if self.view.subviews.last?.tag == 9 {
            self.view.subviews.last?.removeFromSuperview()
        }
        createCarousel()
        tableView.removeFromSuperview()
        createTableView()
        self.tableView.reloadData()
    }
  
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
        view.addGestureRecognizer(tapRecognizer)
    }
  
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearch = false
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            
            searchResult.removeAll()
            isSearch = true
            for game in data!.results {
                if game.name.contains(searchText) {
                    searchResult.append(game)
                }
            }
            if searchResult.isEmpty {
                showNotFound()
                return
            }
            carouselView.removeFromSuperview()
            pageControl.removeFromSuperview()
            self.tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
            self.tableView.reloadData()
            return
        }
        
        if searchText.isEmpty {
            isSearch = false
            tableView.removeFromSuperview()
            createCarousel()
            createTableView()
            tableView.reloadData()
        }
        
        
    }
    
    
    
    
    
}



//MARK: Get Data
extension MainView {
    func getData()  {
        AF.request(Constants.shared.requestURL, method: .get, parameters: nil, headers: HTTPHeaders.init(Constants.shared.requestHeaders), interceptor: nil, requestModifier: nil).response { (response) in
            if let data = response.data {
                do {
                    self.data = try JSONDecoder.init().decode(Games.self, from: data)
                    self.tableView.reloadData()
                }catch {
                    print(error)
                    print(error.localizedDescription)
                }
                
            }
        }
    }
}



//MARK: Table View
extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isSearch) ? searchResult.count : ((data?.results.count ?? 0) - 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.gameCellProperty) as! GameCell
        (isSearch) ? cell.configure(searchResult[indexPath.row]):cell.configure(data!.results[indexPath.row + 3])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameCell
        self.selectedID = cell.id
        performSegue(withIdentifier: Constants.shared.toGameDetail, sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 4 == data!.results.count, !isSearch {
            AF.request(self.data!.next!, method: .get, parameters: nil, headers: HTTPHeaders.init(Constants.shared.requestHeaders), interceptor: nil, requestModifier: nil).response { (response) in
                if let data = response.data {
                    do {
                        let newData = try JSONDecoder.init().decode(Games.self, from: data)
                        self.data!.results.append(contentsOf: newData.results)
                        self.data!.previous = newData.previous
                        self.data!.next = newData.next
                        self.tableView.reloadData()
                    }catch {
                        print(error)
                        print(error.localizedDescription)
                    }

                }
            }
        }
    }
}




