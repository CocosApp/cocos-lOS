//
//  PlacesViewController.swift
//  cocos
//
//  Created by MIGUEL on 13/03/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreLocation
import UIScrollView_InfiniteScroll

enum PlacesButtonSelected {
    case category
    case nearMe
    case discount
}

class PlacesViewController: BaseUIViewController {
    
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var nearMeButton: UIButton!
    @IBOutlet weak var discountsButton: UIButton!
    
    var buttonSelected : PlacesButtonSelected = PlacesButtonSelected.category
    var controller = PlacesController.controller
    var placesList : [SubcategoryEntity] = []
    var placesNearMe : [PlacesEntity] = []
    var discountList : [CardEntity] = []
    var lat : Double!
    var long : Double!
    var subcategoryId : Int?
    var subcategoryName : String?
    var placeNearMeId : String?
    var cardId : String?
    var cardName : String?
    var isLoading : Bool = false
    
    let user : UserEntity = UserEntity.retriveArchiveUser()!
    var kshowPlaceListSegue : String = "showPlaceListSegue"
    var kplaceDetailIdentifier : String = "placeDetailIdentifier"
    var kcardPlacesIdentifier : String = "cardPlacesIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeColor(categoryButton, true)
        changeColor(nearMeButton, false)
        changeColor(discountsButton, false)
        setupTableView()
        startService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func categoryButtonDidSelect(_ sender: UIButton) {
        selectButton(PlacesButtonSelected.category)
    }
    @IBAction func nearMeButtonDidSelect(_ sender: UIButton) {
        selectButton(PlacesButtonSelected.nearMe)
    }
    @IBAction func discountsButtonDidSelect(_ sender: UIButton) {
        selectButton(PlacesButtonSelected.discount)
    }
    
    fileprivate func setupTableView(){
        let loadingNib = UINib(nibName: "LoadListTableViewCell", bundle: nil)
        placesTableView.register(loadingNib, forCellReuseIdentifier: "LoadListTableViewCell")
        placesTableView.addInfiniteScroll { (tableView) -> Void in
                // update table view
                self.nextPage()
                // finish infinite scroll animation
                tableView.finishInfiniteScroll()
        }
    }
    
    fileprivate func selectButton(_ typeButton : PlacesButtonSelected){
        switch typeButton {
        case .category:
            buttonSelected = PlacesButtonSelected.category
            changeColor(categoryButton, true)
            changeColor(nearMeButton, false)
            changeColor(discountsButton, false)
            startService()
            break
        case .nearMe:
            buttonSelected = PlacesButtonSelected.nearMe
            changeColor(categoryButton, false)
            changeColor(nearMeButton, true)
            changeColor(discountsButton, false)
            getFakeLocation()
            break
        case .discount:
            buttonSelected = PlacesButtonSelected.discount
            changeColor(categoryButton, false)
            changeColor(nearMeButton, false)
            changeColor(discountsButton, true)
            startService()
            break
        }
    }
    
    func getFakeLocation(){
        self.lat = -12.072369
        self.long = -77.068706
        self.startService()
    }
    
    func getCurrentLocation() {
        let locationManager = CLLocationManager()
        var currentLocation: CLLocation!
        let authStatus = CLLocationManager.authorizationStatus()
        
        locationManager.requestWhenInUseAuthorization()
        if authStatus == CLAuthorizationStatus.authorizedWhenInUse || authStatus == CLAuthorizationStatus.authorizedAlways {
            currentLocation = locationManager.location
            print(currentLocation)
            if currentLocation != nil{
                self.long = currentLocation.coordinate.longitude
                self.lat = currentLocation.coordinate.latitude
                self.startService()
            }
            else {
                self.lat = -12.072369
                self.long = -77.068706
                self.startService()
            }
        }
    }
    
    fileprivate func changeColor(_ button : UIButton,_ type: Bool){
        if type {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = button.bounds
            gradient.colors = [
                UIColor(red:255/255,green:255/255,blue:255/255,alpha:1).cgColor,
                UIColor(red:255/255,green:255/255,blue:255/255,alpha:1).cgColor,
                UIColor(red:0/255,green:0/255,blue:0/255,alpha:1).cgColor,
                UIColor(red:0/255,green:0/255,blue:0/255,alpha:1).cgColor
            ]
            
            /* repeat the central location to have solid colors */
            gradient.locations = [0, 0.9, 0.9, 1.0]
            
            /* make it vertical */
            gradient.startPoint = CGPoint(x:0.5,y: 0)
            gradient.endPoint = CGPoint(x:0.5,y: 1)
            
            button.layer.insertSublayer(gradient, at: 0)
        }
        else{
            if let layers = button.layer.sublayers{
                if layers.count>1{
                    layers[0].removeFromSuperlayer()
                }
            }
            button.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha:1)
        }
    }
    
    func startService(){
        switch buttonSelected {
        case .category:
            controller.getSubcategoryList(user.token, success: { (places) in
                self.placesList = places
                self.placesTableView.reloadData()
            }, failure: { (error : NSError) in
                self.showErrorMessage(withTitle: error.localizedDescription)
            })
            break
        case .nearMe:
            controller.getPlaceByPosition(user.token, lat: self.lat, long: self.long, success: { (places) in
                self.placesNearMe = places
                self.placesTableView.reloadData()
            }, failure: { (error:NSError) in
                self.showErrorMessage(withTitle: error.localizedDescription)
            })
            break
        case .discount:
            controller.getDiscounts(user.token, success: { (discounts) in
                self.discountList = discounts
                self.placesTableView.reloadData()
            }, failure: { (error:NSError) in
                self.showErrorMessage(withTitle: error.localizedDescription)
            })
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case kshowPlaceListSegue:
            if let controller = segue.destination as? PlaceListViewController {
                controller.subcategoryId = self.subcategoryId!
                controller.subcategoryName = self.subcategoryName!
            }
        case kplaceDetailIdentifier:
            if let controller = segue.destination as? PlaceDetailViewController{
                controller.placeId = self.placeNearMeId!
            }
        case kcardPlacesIdentifier:
            if let controller = segue.destination as? PlacesByCardViewController{
                controller.cardId = self.cardId!
                controller.cardName = self.cardName!
            }
        default:
            break
        }
    }
    
}

extension PlacesViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            switch buttonSelected {
            case .category:
                return placesList.count
            case .nearMe:
                return placesNearMe.count
            case .discount:
                return discountList.count
            }
        }
        else if section == 1 && isLoading {
            return 1
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch buttonSelected {
            case .category:
                let cell = tableView.dequeueReusableCell(withIdentifier: "categoryPlaceCell") as! CategoryPlaceCell
                cell.nameCategory.text = placesList[indexPath.row].name
                if placesList[indexPath.row].image != ""{
                    cell.imageCategory?.af_setImage(withURL: URL(string: placesList[indexPath.row].image)!)
                }
                return cell
            case .nearMe:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nearPlaceCell") as! NearPlaceCell
                cell.namePlace.text = placesNearMe[indexPath.row].name
                if placesNearMe[indexPath.row].photo != ""{
                    cell.imagePlace?.af_setImage(withURL: URL(string: placesNearMe[indexPath.row].photo)!)
                }
                return cell
            case .discount:
                let cell = tableView.dequeueReusableCell(withIdentifier: "discountPlaceCell") as! DiscountPlaceCell
                cell.nameDiscount.text = discountList[indexPath.row].name
                if discountList[indexPath.row].photo != ""{
                    cell.backgroundDiscount.af_setImage(withURL: URL(string: discountList[indexPath.row].photo)!)
                }
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadListTableViewCell") as! LoadListTableViewCell
            cell.loader.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
        }
        else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch buttonSelected {
            case .category:
                subcategoryId = placesList[indexPath.row].id
                subcategoryName = placesList[indexPath.row].name
                performSegue(withIdentifier: self.kshowPlaceListSegue, sender: self)
            case .nearMe:
                placeNearMeId = String(placesNearMe[indexPath.row].id)
                performSegue(withIdentifier: self.kplaceDetailIdentifier, sender: self)
                break
            case .discount:
                cardId = String(discountList[indexPath.row].id)
                cardName = discountList[indexPath.row].name
                performSegue(withIdentifier: self.kcardPlacesIdentifier, sender: self)
                break
            }
        }
    }
    
    //MARK: - Infinite Scrolling
    
    fileprivate func nextPage(){
        placesTableView.reloadSections(IndexSet(integer: 1), with: .none)
        switch buttonSelected {
        case .category:
            controller.getNextSubcategoryList(user.token, success: { (places) in
                self.placesList.append(contentsOf: places)
                self.placesTableView.reloadData()
            }) { (error : NSError) in
                self.showErrorMessage(withTitle: error.localizedDescription)
            }
        case .nearMe:
            controller.getNextPlacesByPosition(user.token, lat: self.lat, long: self.long, success: { (places) in
                self.placesNearMe.append(contentsOf: places)
                self.placesTableView.reloadData()
            }) { (error:NSError) in
                self.showErrorMessage(withTitle: error.localizedDescription)
            }
        case .discount:
            controller.getNextDiscounts(user.token, success: { (card) in
                self.discountList.append(contentsOf: card)
                self.placesTableView.reloadData()
            }) { (error:NSError) in
                self.showErrorMessage(withTitle: error.localizedDescription)
            }
        }
    }
    
}
