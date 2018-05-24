//
//  PlaceDetailViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/05/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

enum PlaceDetailButtonSelected{
    case promotion
    case data
}

class PlaceDetailViewController : UIViewController {
    @IBOutlet weak var pagerImage : ViewPager!
    @IBOutlet weak var dataTableView : UITableView!
    var state = PlaceDetailButtonSelected.data
    var placeId : String!
    var promotionCellIdentifier : String = "promotionPlaceCell"
    var descriptionCellIdentifier : String = "descriptionPlaceCell"
    var placeDetail = PlaceDetailEntity(){
        didSet{
            self.dataTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    @IBAction func promotionButtonDidSelect(_ sender:UIButton){
        self.reloadData(data: .promotion)
    }
    @IBAction func dataButtonDidSelect(_ sender:UIButton){
        self.reloadData(data: .data)
    }
    @IBAction func uberDriveButtonDidSelect(_ sender: UIButton){
        
    }
    @IBAction func callPlaceButtonDidSelect(_ sender: UIButton){
        
    }
    
    func reloadData(data : PlaceDetailButtonSelected){
        self.state = data
        self.dataTableView.reloadData()
    }
    
    func loadData(){
        let controller = PlaceDetailController.controller
        controller.getDetail(placeId: placeId, success: { (place) in
            self.placeDetail = place
        }) { (error) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
}
extension PlaceDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .data{
            return 1
        }
        else{
            return placeDetail.discount.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if state == .data{
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier, for: indexPath) as! DescriptionPlaceCell
            cell.placeDetail = placeDetail
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: promotionCellIdentifier, for: indexPath) as! PromotionPlaceCell
            cell.promotion = placeDetail.discount[indexPath.row]
            return cell
        }
    }
    
    
}
