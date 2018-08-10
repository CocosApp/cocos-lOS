//
//  NearMeViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import CoreLocation
import UIScrollView_InfiniteScroll

class NearMeViewController: BaseUIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var placesNearMe : [PlacesEntity] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var lat : Double!
    var long : Double!
    var placeSelected : PlacesEntity!
    let controller = PlacesController.controller
    let user : UserEntity = UserEntity.retriveArchiveUser()!
    let kplaceDetailIdentifier : String = "placeDetailIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.startLocationUpdate()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupService()
    }
    
    fileprivate func setupService(){
        if LocationManager.sharedInstance.notDetermined {
            
            LocationManager.sharedInstance.requestPermission()
        }
        else if LocationManager.sharedInstance.hasPermission()
        {
            LocationManager.sharedInstance.delegate = self
            LocationManager.sharedInstance.startLocationUpdate()
        }
        else
        {
            self.present(LocationManager.sharedInstance.alertGPS(), animated: true, completion: nil)
        }
    }
    
    fileprivate func startService(){
        controller.getPlaceByPosition(user.token, lat: self.lat, long: self.long, success: { (places) in
            self.placesNearMe = places
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
        controller.getNextPlacesByPosition(user.token, lat: self.lat, long: self.long, success: { (places) in
            self.placesNearMe.append(contentsOf: places)
        }) { (error:NSError) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kplaceDetailIdentifier {
            if let vc = segue.destination as? PlaceDetailViewController{
                vc.placeId = String(placeSelected.id)
            }
        }
    }
    
}

extension NearMeViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNearMe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearPlaceCell") as! NearPlaceCell
        cell.namePlace.text = placesNearMe[indexPath.row].name
        if placesNearMe[indexPath.row].photo != ""{
            cell.imagePlace?.af_setImage(withURL: URL(string: placesNearMe[indexPath.row].photo)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.placeSelected = self.placesNearMe[indexPath.row]
        performSegue(withIdentifier: kplaceDetailIdentifier, sender: self)
    }
}

extension NearMeViewController : LocationDelegate {
    func getLocation(coord: CLLocationCoordinate2D) {
        self.lat = coord.latitude
        self.long = coord.longitude
        self.startService()
    }
}
