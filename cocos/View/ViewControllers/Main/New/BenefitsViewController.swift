//
//  BenefitsViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class BenefitsViewController: BaseUIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var discountList : [CardEntity] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    let controller = PlacesController.controller
    let user : UserEntity = UserEntity.retriveArchiveUser()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startService()
    }
    
    fileprivate func startService(){
        controller.getDiscounts(user.token, success: { (card) in
            self.discountList = card
        }) { (error:NSError) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
    fileprivate func setupTableView(){
        tableView.addInfiniteScroll { (tableView) -> Void in
            // update table view
            self.nextPage()
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    fileprivate func nextPage(){
        controller.getNextDiscounts(user.token, success: { (card) in
            self.discountList.append(contentsOf: card)
        }) { (error:NSError) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }

}

extension BenefitsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountPlaceCell") as! DiscountPlaceCell
        cell.nameDiscount.text = discountList[indexPath.row].name
        if discountList[indexPath.row].photo != ""{
            cell.backgroundDiscount.af_setImage(withURL: URL(string: discountList[indexPath.row].photo)!)
        }
        return cell
    }
}
