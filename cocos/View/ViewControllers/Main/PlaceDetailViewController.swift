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
    var state = PlaceDetailButtonSelected.promotion
    var placeId : String!
    var user : UserEntity!
    let kshowCarPopUpIdentifier : String = "showCarPopUpIdentifier"
    let kshowDiscountDescriptionIdentifier : String = "showDiscountDescriptionIdentifier"
    let promotionCellIdentifier : String = "promotionPlaceCell"
    let descriptionCellIdentifier : String = "descriptionPlaceCell"
    var promotionSelected : PromotionEntity!
    var placeDetail = PlaceDetailEntity(){
        didSet{
            self.title = placeDetail.name
            self.dataTableView.reloadData()
            self.pagerImage.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserEntity.retriveArchiveUser()
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
        performSegue(withIdentifier: kshowCarPopUpIdentifier, sender: self)
    }
    
    @IBAction func callPlaceButtonDidSelect(_ sender: UIButton){
        let mobile : String = self.placeDetail.mobile.replacingOccurrences(of: " ", with: "")
        print(mobile)
        if let url = URL(string: "tel://\(mobile)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            
        }
    }
    
    func reloadData(data : PlaceDetailButtonSelected){
        self.state = data
        self.dataTableView.reloadData()
    }
    
    @IBAction func likeButtonDidSelect(_ sender: UIBarButtonItem) {
        if user.firstName == "INVITADO"{
            self.showErrorMessage(withTitle: "No se puede agregar a favoritos como invitado, por favor registrarse para continuar")
        }
        else{
            let controller = PlaceDetailController.controller
            controller.addFavoritePlace(placeId: placeId, success: { (response) in
                self.likeBarButtonItem.image = #imageLiteral(resourceName: "like_on")
            }) { (error) in
                self.showSuccessMessage(withTitle: "Usted ya cuenta con este restaurante como favorito")
            }
        }
    }
    
    
    @IBAction func shareButtonDidSelect(_ sender: UIBarButtonItem) {
//        if let image = self.placeDetail.photo1 {
//            self.downloadShareImage(imageUrl: image)
//        }
        if let image = self.pagerImage.itemViews[0]?.toImage() {
            self.shareWithSocialMedia(image: image)
        }
    }
    
    func shareWithSocialMedia(image : UIImage){
        let text = self.placeDetail.getShareText()
        let shareAll = [text,image] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func downloadShareImage(imageUrl : String?){
        if let imageurl = imageUrl{
            DataRequest.addAcceptableImageContentTypes(["image/jpg"])
            self.showActivityIndicator()
            Alamofire.request(imageurl, method: .get).responseImage { response in
                self.hideActivityIndicator()
                if let data = response.result.value {
                    let text = self.placeDetail.getShareText()
                    let myWebsite : NSURL!
                    if self.placeDetail.facebook != ""{
                        myWebsite = NSURL(string:self.placeDetail.facebook)!
                    }
                    else {
                        myWebsite = NSURL(string:"https://appcocos.com")!
                    }
                    let shareAll = [text,data] as [Any]
                    let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                } else {
                    let text = self.placeDetail.getShareText()
                    let myWebsite : NSURL!
                    if self.placeDetail.facebook != ""{
                        myWebsite = NSURL(string:self.placeDetail.facebook)!
                    }
                    else {
                        myWebsite = NSURL(string:"https://appcocos.com")!
                    }
                    let shareAll = [text] as [Any]
                    let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
        else{
            let text = "Todos los descuentos en un solo sito"
            let myWebsite : NSURL!
            if self.placeDetail.facebook != ""{
                myWebsite = NSURL(string:self.placeDetail.facebook)!
            }
            else {
                myWebsite = NSURL(string:"https://appcocos.com")!
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kshowDiscountDescriptionIdentifier {
            if let vc = segue.destination as? DiscountDescriptionViewController {
                vc.promotion = self.promotionSelected
                vc.templateImage = self.placeDetail.photo1
            }
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
            cell.placeDetailDelegate = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: promotionCellIdentifier, for: indexPath) as! PromotionPlaceCell
            cell.promotion = placeDetail.discount[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if state == .promotion {
            self.promotionSelected = self.placeDetail.discount[indexPath.row]
            if self.promotionSelected.price != 0 || self.promotionSelected.promotion != "" {
                self.performSegue(withIdentifier: "showDiscountDescriptionIdentifier", sender: self)
            }
            else{
                let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
                customAlert.providesPresentationContextTransitionStyle = true
                customAlert.definesPresentationContext = true
                customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                customAlert.termsAndConditions = self.promotionSelected.terms_condition
                self.present(customAlert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if state == .data{
            return 360
        }
        else{
            return 60
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
        if placeDetail.photo1 != nil && placeDetail.photo1 != ""{
            num=num+1
        }
        if placeDetail.photo2 != nil && placeDetail.photo2 != "" {
            num=num+1
        }
        if placeDetail.photo3 != nil && placeDetail.photo3 != ""{
            num=num+1
        }
        return num
    }
    
}

extension PlaceDetailViewController : ErrorMessageDelegate {
    func withError(error: String) {
        self.showErrorMessage(withTitle: error)
    }
    
    func withMessage(message : String){
        self.showSuccessMessage(withTitle: message)
    }
    
}
