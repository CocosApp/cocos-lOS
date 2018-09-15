//
//  CategoryViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import Firebase
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
    let kshowPlaceListSegue : String = "showPlaceListSegue"
    var subcategorySelected : SubcategoryEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startService()
    }
    
    fileprivate func startService(){
        self.showActivityIndicator()
        controller.getSubcategoryList(user.token, success: { (places) in
            self.hideActivityIndicator()
            self.placesList = places
        }, failure: { (error : NSError) in
            self.hideActivityIndicator()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kshowPlaceListSegue {
            if let vc = segue.destination as? PlaceListViewController{
                vc.subcategoryId = self.subcategorySelected.id
                vc.subcategoryName = self.subcategorySelected.name
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.subcategorySelected = self.placesList[indexPath.row]
        //Analytics
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let actualDate = formatter.string(from: date)
        let params = ["id_category":subcategorySelected.id,"name_category":subcategorySelected.name,"id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"detail_category","so":"ios"] as [String:Any]
        Analytics.logEvent("detail_category", parameters: params)
        
        performSegue(withIdentifier: kshowPlaceListSegue, sender: self)
    }
}
