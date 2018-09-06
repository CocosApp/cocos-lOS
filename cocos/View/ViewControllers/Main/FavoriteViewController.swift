//
//  FavoriteViewController.swift
//  cocos
//
//  Created by MIGUEL on 22/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

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
        self.setupTableView()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func loadData(){
        let controller = FavoriteController.controller
        self.showActivityIndicator()
        controller.getFavoritePlaces(success: { (places) in
            self.hideActivityIndicator()
            self.favoritePlaces = places
        }) { (error) in
            self.hideActivityIndicator()
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
    fileprivate func setupTableView(){
        favoriteTableView.addInfiniteScroll { (tableView) -> Void in
            // update table view
            self.nextPage()
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    func nextPage(){
        let controller = FavoriteController.controller
        controller.getNextFavoritePlaces(success: { (places) in
            self.favoritePlaces.append(contentsOf: places)
        }) { (error) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kPlaceDetailIdentifier {
            if let viewController = segue.destination as? PlaceDetailViewController {
                let id : Int = (self.place.place?.id)!
                viewController.placeId = String(id)
                viewController.origin = "Favorites"
            }
        }
    }
    
    fileprivate func deselectLike(places : FavoritePlaceEntity){
        let controller = FavoriteController.controller
        let id : String  = String((places.place?.id)!)
        controller.deleteFavoritePlace(placeId: id, success: {
            self.showSuccessMessage(withTitle: "Eliminado de favoritos")
            self.loadData()
        }) { (error) in
            self.showSuccessMessage(withTitle: "Eliminado de favoritos")
            self.loadData()
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
        cell.descriptionLabel.text = favoritePlace.place?.getSubcategoryString()
        let photo : String = (favoritePlace.place?.photo)!
        if photo != ""{
            cell.placeBackgroundView?.af_setImage(withURL: URL(string: photo)!)
        }
        cell.likeOff = {
            self.deselectLike(places:self.favoritePlaces[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
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
