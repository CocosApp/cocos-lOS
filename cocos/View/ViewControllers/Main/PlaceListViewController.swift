//
//  PlaceListViewController.swift
//  cocos
//
//  Created by MIGUEL on 12/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit



class PlaceListViewController : UIViewController {
    @IBOutlet weak var listTableView : UITableView!
    var lat : Double!
    var long : Double!
    var place :PlacesEntity!
    let kPlaceDetailIdentifier:String="placeDetailIdentifier";
    var placesList : [PlacesEntity] = []{
        didSet{
            listTableView.reloadData()
        }
    }
    var subcategoryId:Int!
    var subcategoryName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.subcategoryName
        self.getFakeLocation()
    }
    
    fileprivate func setupTableView(){
        listTableView.addInfiniteScroll { (tableView) -> Void in
            // update table view
            self.nextPage()
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    fileprivate func nextPage(){
        
    }
    
    func getFakeLocation(){
        self.lat = -12.072369
        self.long = -77.068706
        self.loadList()
    }
    
    private func loadList(){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        let controller = PlaceListController.controller
        let subcategory : String = String(subcategoryId)
        let latitude : String = String(lat)
        let longitude : String = String(long)
        controller.loadList(user.token, subcategoryId: subcategory,latitude: latitude,longitude: longitude, success: { (places) in
            self.placesList = places
        }) { (error:NSError) in
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

extension PlaceListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeListCell") as! PlaceListCell
        cell.lblTitle.text = placesList[indexPath.row].name
        cell.backgroundImageView?.af_setImage(withURL: URL(string: placesList[indexPath.row].photo)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.place = placesList[indexPath.row];
        performSegue(withIdentifier: kPlaceDetailIdentifier, sender: self)
    }
    
    
}
