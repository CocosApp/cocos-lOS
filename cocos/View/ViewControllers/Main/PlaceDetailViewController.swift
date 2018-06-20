//
//  PlaceDetailViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/05/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

enum PlaceDetailButtonSelected{
    case promotion
    case data
}

class PlaceDetailViewController : UIViewController {
    @IBOutlet weak var pagerImage : ViewPager!
    @IBOutlet weak var dataTableView : UITableView!
    @IBOutlet weak var likeBarButtonItem: UIBarButtonItem!
    var state = PlaceDetailButtonSelected.data
    var placeId : String!
    var promotionCellIdentifier : String = "promotionPlaceCell"
    var descriptionCellIdentifier : String = "descriptionPlaceCell"
    var placeDetail = PlaceDetailEntity(){
        didSet{
            self.dataTableView.reloadData()
            self.pagerImage.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pagerImage.dataSource = self
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
    @IBAction func likeButtonDidSelect(_ sender: UIBarButtonItem) {
    }
    
    func reloadData(data : PlaceDetailButtonSelected){
        self.state = data
        self.dataTableView.reloadData()
    }
    @IBAction func shareButtonDidSelect(_ sender: UIBarButtonItem) {
        if let image = self.placeDetail.photo1 {
            self.downloadShareImage(imageUrl: image)
        }
    }
    
    func downloadShareImage(imageUrl : String?){
        //let downloader = ImageDownloader()
        if let imageurl = imageUrl{
            //let urlRequest = URLRequest(url: URL(string: imageurl)!)
            DataRequest.addAcceptableImageContentTypes(["image/jpg"])
            Alamofire.request(imageurl, method: .get).responseImage { response in
                if let data = response.result.value {
                    let text = "Todos los descuentos en un solo sito"
                    let myWebsite : NSURL = NSURL(string:"https://appcocos.com")!
                    let shareAll = [text,data,myWebsite] as [Any]
                    let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                } else {
                    let text = "Todos los descuentos en un solo sito"
                    let myWebsite : NSURL = NSURL(string:"https://appcocos.com")!
                    let shareAll = [text, myWebsite] as [Any]
                    let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
        else{
            let text = "Todos los descuentos en un solo sito"
            let myWebsite : NSURL = NSURL(string:"https://appcocos.com")!
            let shareAll = [text, myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if state == .data{
            return 360
        }
        else{
            return 80
        }
    }
}

extension PlaceDetailViewController : ViewPagerDataSource {
    func numberOfItems(_ viewPager: ViewPager) -> Int {
        return self.placeSize()
    }
    
    func viewAtIndex(_ viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
        let imageView : UIImageView = UIImageView()
        switch index {
        case 0:
            imageView.af_setImage(withURL: URL(string: self.placeDetail.photo1!)!)
        case 1:
            imageView.af_setImage(withURL: URL(string: self.placeDetail.photo2!)!)
        case 2:
            imageView.af_setImage(withURL: URL(string: self.placeDetail.photo3!)!)
        default:
            imageView.af_setImage(withURL: URL(string: self.placeDetail.photo1!)!)
        }
        imageView.sizeToFit()
        return imageView
    }
    
    func placeSize()->Int{
        var num : Int = 0
        if placeDetail.photo1 != nil{
            num=num+1
        }
        if placeDetail.photo2 != nil {
            num=num+1
        }
        if placeDetail.photo3 != nil{
            num=num+1
        }
        return num
    }
    
    
}
