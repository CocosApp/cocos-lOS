//
//  FavoriteViewController.swift
//  cocos
//
//  Created by MIGUEL on 22/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class FavoriteViewController : BaseUIViewController {
    
    @IBOutlet weak var favoriteSearchBar: UISearchBar!
    @IBOutlet weak var favoriteTableView: UITableView!
    
    let kPlaceDetailIdentifier:String = "placeDetailIdentifier"
    var place : FavoritePlaceEntity!
    
    var favoritePlaces : [FavoritePlaceEntity] = [] {
        didSet{
            favoriteTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    private func loadData(){
        let controller = FavoriteController.controller
        controller.getFavoritePlaces(success: { (places) in
            self.favoritePlaces = places
        }) { (error) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kPlaceDetailIdentifier {
            if let viewController = segue.destination as? PlaceDetailViewController {
                let id : Int = (self.place.place?.id)!
                viewController.placeId = String(id)
            }
        }
    }
    
}

extension FavoriteViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritePlaceCell") as! FavoritePlaceCell
        let favoritePlace = favoritePlaces[indexPath.row]
        cell.titleLabel.text = favoritePlace.place?.name
        let photo : String = (favoritePlace.place?.photo)!
        if photo != ""{
            cell.placeBackgroundView?.af_setImage(withURL: URL(string: photo)!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.place = self.favoritePlaces[indexPath.row]
        performSegue(withIdentifier: kPlaceDetailIdentifier, sender: self)
    }
}

extension FavoriteViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.favoriteSearchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.favoriteSearchBar.endEditing(true)
    }
    
}
