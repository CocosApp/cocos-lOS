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
    @IBOutlet weak var travelView: UIView!
    @IBOutlet weak var reservationView: UIView!
    
    var state = PlaceDetailButtonSelected.promotion
    var placeId : String!
    var user : UserEntity!
    let kshowCarPopUpIdentifier : String = "showCarPopUpIdentifier"
    let kshowDiscountDescriptionIdentifier : String = "showDiscountDescriptionIdentifier"
    let promotionCellIdentifier : String = "promotionPlaceCell"
    let descriptionCellIdentifier : String = "descriptionPlaceCell"
    var promotionSelected : PromotionEntity!
    
    var origin : String = ""
    var tapGestureTravel = UITapGestureRecognizer()
    var tapGestureReservation = UITapGestureRecognizer()
    fileprivate lazy var docInteractionController: UIDocumentInteractionController = {
        return UIDocumentInteractionController()
    }()
    
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
        
        if self.origin == "Favorites"{
            self.likeBarButtonItem.image = #imageLiteral(resourceName: "like_on")
        }else{
            self.likeBarButtonItem.image = #imageLiteral(resourceName: "like_off")
        }
        
        setConfigurationsTapGestures()
        
        self.loadData()
    }
    
    func setConfigurationsTapGestures(){
        tapGestureTravel = UITapGestureRecognizer(target: self, action: #selector(self.uberDriveButtonDidSelect(_:)))
        tapGestureReservation = UITapGestureRecognizer(target: self, action: #selector(self.callPlaceButtonDidSelect(_:)))
        
        self.travelView.addGestureRecognizer(tapGestureTravel)
        self.reservationView.addGestureRecognizer(tapGestureReservation)
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
        /*var image : UIImage = takeScreenshot()!
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        print(strBase64)
        */
        /*let imageData = UIImagePNGRepresentation(image)!
        let strBase64 = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        */
        //self.saveBase64StringToPDF(strBase64 , "compartir.jpg")
        /*if let image = self.pagerImage.itemViews[0]?.toImage() {
            self.shareWithSocialMedia(image: image)
        }*/
 
        guard let image = takeScreenshot() else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (nil, completed, _, error) in
            if completed {
                print("Completado")
            } else {
                print("Cancelado")
            }
        }
        present(activityController, animated: true) {
            print("Presentado")
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
    
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
        //return #imageLiteral(resourceName: "about_icon")
    }
    
    
    
    func saveBase64StringToPDF(_ base64String: String, _ nameFile: String) {
        //let fileURL = NSBundle.mainBundle().URLForResource("MyFile", withExtension: "txt")!
        //var fileURL = (FileManager.default)
        /*let path =  Bundle.main.path(forResource: "Guide", ofType: ".pdf")!
        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
        dc.delegate = self
        dc.presentPreview(animated: true)
        */
        //let urlFile = Bundle.main.url(forResource: "Filename", withExtension: "JPEG", subdirectory: ., localization: nil)
        
        
        
        guard
            var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
            else {
                //handle error when getting documents URL
                return
        }
        
        let convertedData = Data(base64Encoded: base64String)
        //name your file however you prefer
        documentsURL.appendPathComponent(nameFile)
        
        do {
            
            try convertedData?.write(to: documentsURL as URL)
            
            // Save file
            var url = URL(fileURLWithPath: documentsURL.absoluteString)
            url = documentsURL
            docInteractionController.url = url as URL
            docInteractionController.delegate = self
            
            if docInteractionController.presentPreview(animated: true) {
                // Successfully displayed
                self.docInteractionController.url = url
                self.docInteractionController.delegate = self
            } else {
                // Couldn't display
            }
            
        } catch {
            //handle write error here
            self.hideActivityIndicator()
        }
        
        //if you want to get a quick output of where your
        //file was saved from the simulator on your machine
        //just print the documentsURL and go there in Finder
        print(documentsURL)
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

extension PlaceDetailViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        // I tend to use 'navigationController ?? self' here but depends on implementation
        return self
    }
}
