//
//  PlacesByCardViewController.swift
//  cocos
//
//  Created by MIGUEL on 21/06/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class PlacesByCardViewController: UIViewController {
    @IBOutlet weak var placesByCardTableView: UITableView!
    let descriptionCellIdentifier : String = "placeListCell"
    let kPlaceDetailIdentifier:String="placeDetailIdentifier";
    
    var place :PlacesEntity!
    var places : [PlacesEntity] = [] {
        didSet{
            placesByCardTableView.reloadData()
        }
    }
    var cardId: String!
    var cardName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.cardName
        self.setupTableView()
        self.loadData()
    }
    
    fileprivate func setupTableView(){
        placesByCardTableView.addInfiniteScroll { (tableView) -> Void in
            // update table view
            //self.nextPage()
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    func loadData(){
        self.showActivityIndicator()
        let controller = PlacesByCardController.controller
        controller.getList(cardId: cardId, success: { (places) in
            self.hideActivityIndicator()
            self.places = places
        }) { (error) in
            self.hideActivityIndicator()
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == kPlaceDetailIdentifier){
            if let viewController = segue.destination as? PlaceDetailViewController {
                viewController.placeId = String(self.place.id)
            }
        }
    }
    
}

extension PlacesByCardViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier, for: indexPath) as! PlaceListCell
        let entity = places[indexPath.row]
        cell.lblTitle.text = entity.name
        if entity.photo != "" {
            cell.backgroundImageView?.af_setImage(withURL: URL(string: entity.photo)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.place = places[indexPath.row];
        performSegue(withIdentifier: kPlaceDetailIdentifier, sender: self)
    }
    
}
