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
    
    var kshowPlaceListSegue : String = "showPlaceListSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            button.backgroundColor = UIColor(red: 207/255, green: 2/255, blue: 9/255, alpha: 1)
        }
        else{
            button.backgroundColor = UIColor.white
        }
    }
    
    func startService(){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
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
    
}

extension PlacesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch buttonSelected {
        case .category:
            return placesList.count
        case .nearMe:
            return placesNearMe.count
        case .discount:
            return discountList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch buttonSelected {
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryPlaceCell") as! CategoryPlaceCell
            cell.nameCategory.text = placesList[indexPath.row].name
            cell.imageCategory?.af_setImage(withURL: URL(string: placesList[indexPath.row].image)!)
            return cell
        case .nearMe:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nearPlaceCell") as! NearPlaceCell
            cell.namePlace.text = placesNearMe[indexPath.row].name
            cell.imagePlace?.af_setImage(withURL: URL(string: placesNearMe[indexPath.row].photo)!)
            return cell
        case .discount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "discountPlaceCell") as! DiscountPlaceCell
            cell.nameDiscount.text = discountList[indexPath.row].name
            cell.backgroundDiscount.af_setImage(withURL: URL(string: discountList[indexPath.row].photo)!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch buttonSelected {
        case .category:
            subcategoryId = placesList[indexPath.row].id
            performSegue(withIdentifier: self.kshowPlaceListSegue, sender: self)
        case .nearMe:
            break
        case .discount:
            break
        }
        //performSegue(withIdentifier: self.kShowOrderDetailSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case kshowPlaceListSegue:
            if let controller = segue.destination as? PlaceListViewController {
                controller.subcategoryId = self.subcategoryId!
            }
        default:
            break
        }
    }
}
