//
//  CategoryViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import AlamofireImage
import UIScrollView_InfiniteScroll

class CategoryViewController: BaseUIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var placesList : [SubcategoryEntity] = []{
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
        controller.getSubcategoryList(user.token, success: { (places) in
            self.placesList = places
        }, failure: { (error : NSError) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        })
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
        controller.getNextSubcategoryList(user.token, success: { (places) in
            self.placesList.append(contentsOf: places)
        }) { (error : NSError) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }

}

extension CategoryViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryPlaceCell") as! CategoryPlaceCell
        cell.nameCategory.text = placesList[indexPath.row].name
        if placesList[indexPath.row].image != ""{
            cell.imageCategory?.af_setImage(withURL: URL(string: placesList[indexPath.row].image)!)
        }
        return cell
    }
}
