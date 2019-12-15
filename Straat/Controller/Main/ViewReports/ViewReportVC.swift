//
//  ViewReportVC.swift
//  Straat
//
//  Created by Global Array on 24/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewReportVC: UIViewController {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var mainCategoryName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var reportedBy: UILabel!
    
    @IBOutlet weak var reportImageUIView: UIView!
    @IBOutlet weak var reportImageViewConsraint: NSLayoutConstraint!
    @IBOutlet weak var reportIsPublicLbl: UILabel!
    @IBOutlet weak var reportIsPublic: UILabel!
    @IBOutlet weak var reportStatusIndicator: UIImageView!
    @IBOutlet weak var reportStatusPin: UIImageView!
    @IBOutlet weak var updateStatusBtn: UIButton!
    @IBOutlet weak var updateIsPublicBtn: UIButton!
    
    let reportService = ReportService()
    let uds = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initReportMapDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUpdateReportStatus(_ sender: Any) {
        print("UPDATE_STATUS: CLICKING")
        self.updateStatusDialog()
    }
    @IBAction func onUpdateReportIsPublic(_ sender: Any) {
        self.updateIsPublicDialog()
    }
}

extension ViewReportVC {
    
    
    func initReportMapDetails() -> Void{

        let address = uds.string(forKey: report_address)
        let date = uds.string(forKey: report_created_at)
        let category = uds.string(forKey: report_category)
        let status = uds.string(forKey: report_status_detail_view)
        let statusVal = uds.string(forKey: report_status_value)
        let message = uds.string(forKey: report_message)
        let imageUrls = uds.array(forKey: report_images) as! [String]
        let isPublic = uds.bool(forKey: report_is_public)
        
//        let fname = uds.string(forKey: user_fname)
//        let lname = uds.string(forKey: user_lname)
        let fullname = uds.string(forKey: report_reporter_fullname)
        let reporterUsername = uds.string(forKey: report_reporter_username)
        let reporterId = uds.string(forKey: report_reporter_id)
        
        self.location.text = address
        self.date.text = date
        self.status.text = status
        self.mainCategoryName.text = category
        self.message.text = message
        self.reportedBy.text = reporterUsername
        self.reportIsPublic.text = isPublic ? NSLocalizedString("yes", comment: "") : NSLocalizedString("no", comment: "")
        
        self.initImageViews(imageUrls: imageUrls)
        print("report fullname: \(String(describing: fullname))")
        self.loadStatusIndicator(status: statusVal)
        let reportTypeCode = uds.string(forKey: report_type_code)
        self.loadIsPublicInfo(code: reportTypeCode)
        self.setBtnEnable(statusVal: statusVal, reporterId: reporterId, isPublic: isPublic)
    }
    
    func initImageViews(imageUrls : [String]) -> Void {
        
        loadingShow(vc: self)
        
        print("image url count: \(imageUrls.count)")
        
        if imageUrls.count > 0 {
            
            self.getReportImageFromUrl(imageUrls: imageUrls) { (hasImage, images, yAxis, viewHeight) in
                if hasImage {
                    self.setImageViews(reportViewImage: images!, yAxis: yAxis, viewHeight: viewHeight)
                }
//                else {
//                    defaultDialog(vc: self, title: "Fetching image", message: "Image not found")
//                }
                loadingDismiss()
            }
            
        } else {
            let desc = NSLocalizedString("image-not-found", comment: "")
            defaultDialog(vc: self, title: "Fetching images", message: desc)
            loadingDismiss()
        }
        
    }
    
    
    func getReportImageFromUrl (imageUrls : [String], completion: @escaping (Bool, UIImage?, CGFloat, CGFloat) -> Void) -> Void {
        
        var yAxis : CGFloat = 0
        var viewHeight : CGFloat = 205
        for imageUrl in imageUrls {
            
            Alamofire.request(URL(string: imageUrl)!).responseImage { response in
                
                if let img = response.result.value {
                    print("view report image downloaded: \(img)")
                    
                    DispatchQueue.main.async {
    
                        completion(true, img, yAxis, viewHeight)
                        yAxis += 205
                        viewHeight += 205
                    }
                    
                } else {
                    completion(false, nil, 0, 0)
                }
            }
        }
        
    }
    
    
    func setImageViews( reportViewImage : UIImage, yAxis : CGFloat, viewHeight : CGFloat) -> Void {
        
        let image = UIImageView(frame: CGRect(x: 0, y: yAxis, width: self.reportImageUIView.frame.width, height: 200))
        
        image.image = reportViewImage
        self.reportImageViewConsraint.constant = viewHeight
        self.reportImageUIView.autoresizesSubviews = true
        self.reportImageUIView.addSubview(image)
        self.reportImageUIView.clipsToBounds = true;
        
        print("view created")
        print("image height \(yAxis)")
        print("imageview height \(self.reportImageViewConsraint.constant)")
        
    }
    
    func loadStatusIndicator (status: String?) {
        
        switch status {
        case "NEW":
            print("STATUS_: new")
            self.reportStatusIndicator.image = UIImage(named: "status-new")
            self.reportStatusPin.image = UIImage(named: "pin-new")
        case "INPROGRESS":
            print("STATUS_: inprogess")
            self.reportStatusIndicator.image = UIImage(named: "status-inprogress")
            self.reportStatusPin.image = UIImage(named: "pin-inprogress")
        case "EXPIRED":
            print("STATUS_: expired")
            self.reportStatusIndicator.image = UIImage(named: "status-expired")
            self.reportStatusPin.image = UIImage(named: "pin-expired")
        case "DONE":
            print("STATUS_: done")
            self.reportStatusIndicator.image = UIImage(named: "status-done")
            self.reportStatusPin.image = UIImage(named: "pin-done")
        default:
            print("STATUS_: default")
            self.reportStatusIndicator.image = UIImage(named: "status-done")
            self.reportStatusPin.image = UIImage(named: "pin-done")
        }
    }
    
    func loadIsPublicInfo (code: String?) {
        print("REPORT_TYPE_CODE: \(code)")
        if code == "B" {
            self.reportIsPublic.isHidden = false
            self.reportIsPublicLbl.isHidden = false
            self.updateIsPublicBtn.isHidden = false
        } else {
            self.reportIsPublic.isHidden = true
            self.reportIsPublicLbl.isHidden = true
            self.updateIsPublicBtn.isHidden = true
            self.updateIsPublicBtn.isEnabled = false
        }
    }
    
    func setBtnEnable (statusVal: String?, reporterId: String?, isPublic: Bool) {
        let user = UserModel()
        self.updateStatusBtn.isEnabled = statusVal == "NEW" || statusVal == "INPROGRESS"
        self.updateIsPublicBtn.isEnabled = reporterId != nil && user.id != nil && reporterId == user.id && !isPublic
        
        if statusVal == "NEW" || statusVal == "INPROGRESS" {
            
        } else {
            self.updateStatusBtn.backgroundColor = UIColor.lightGray
            
        }
        
        if reporterId != nil && user.id != nil && reporterId == user.id && !isPublic {
            
        } else {
            self.updateIsPublicBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    func updateStatusDialog () {
        let title = ""
        let message = NSLocalizedString("report-update-status-notif", comment: "")
        let negativeBtnName = NSLocalizedString("no", comment: "")
        let positiveBtnName = NSLocalizedString("yes", comment: "")
        
        alertDialogWithPositiveAndNegativeButton(vc: self, title: title, message: message, positiveBtnName: positiveBtnName, negativeBtnName: negativeBtnName, positiveHandler: { (positiveUIAlertAction) in
            
            self.updateStatus()
            
        }) { (negativeUIAlertAction) in
            
        }
    }
    
    func updateIsPublicDialog () {
        let title = ""
        let message = NSLocalizedString("report-make-public-notif", comment: "")
        let negativeBtnName = NSLocalizedString("no", comment: "")
        let positiveBtnName = NSLocalizedString("yes", comment: "")
        
        alertDialogWithPositiveAndNegativeButton(vc: self, title: title, message: message, positiveBtnName: positiveBtnName, negativeBtnName: negativeBtnName, positiveHandler: { (positiveUIAlertAction) in
            
            self.updateIsPublic()
            
        }) { (negativeUIAlertAction) in
            
        }
    }
    
    func updateStatus () {
        let reportId = uds.string(forKey: report_id)
        print(reportId)
        if reportId != nil {
            self.reportService.updateReportStatus(reportId: reportId!, status: "DONE") { (success) in
                if success {
                    self.reportStatusIndicator.image = UIImage(named: "status-done")
                    self.reportStatusPin.image = UIImage(named: "pin-done")
                    self.updateStatusBtn.backgroundColor = UIColor.lightGray
                    self.status.text = NSLocalizedString("report-status-done", comment: "")
                    self.updateStatusBtn.isEnabled = false
                    let title = ""
                    let message = NSLocalizedString("report-update-status-done", comment: "")
                    let positiveBtn = "OK"
                    alertDialogWithPositiveButton(vc: self, title: title, message: message, positiveBtnName: positiveBtn, handler: { (uiAlert) in
                        
                    })
                }
            }
        }
    }
    
    func updateIsPublic () {
        let reportId = uds.string(forKey: report_id)
        if reportId != nil {
            self.reportService.makeReportPublic(reportId: reportId!) { (success) in
                if success {
                    self.updateIsPublicBtn.backgroundColor = UIColor.lightGray
                    self.updateIsPublicBtn.isEnabled = false
                    self.reportIsPublic.text = NSLocalizedString("yes", comment: "")
                    let title = ""
                    let message = NSLocalizedString("report-make-public-done", comment: "")
                    let positiveBtn = "OK"
                    alertDialogWithPositiveButton(vc: self, title: title, message: message, positiveBtnName: positiveBtn, handler: { (uiAlert) in
                        
                    })
                }
            }
        }
    }
}
