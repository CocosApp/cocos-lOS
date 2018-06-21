//
//  PlacesByCardViewController.swift
//  cocos
//
//  Created by MIGUEL on 21/06/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class PlacesByCardViewController: UIViewController {
    @IBOutlet weak var placesByCardTableView: UITableView!
    let descriptionCellIdentifier : String = "placeListCell"
    
    var places : [PlacesEntity] = [] {
        didSet{
            placesByCardTableView.reloadData()
        }
    }
    var cardId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
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
}

extension PlacesByCardViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier, for: indexPath) as! PlaceListCell
        return cell
    }
    
    
}
