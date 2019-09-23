//
//  ViewReport.swift
//  Straat
//
//  Created by Global Array on 18/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

protocol ReportDelegate {
    func didReportUpdated(didUpdate: Bool)
}

class ViewMapReportVC: UIViewController {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var reportBy: UILabel!
    @IBOutlet weak var reportImageView: UIView!
    @IBOutlet weak var reportImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var reportIsPublic: UILabel!
    @IBOutlet weak var reportStatusIndicator: UIImageView!
    @IBOutlet weak var reportStatusPin: UIImageView!
    @IBOutlet weak var isReportPublicLbl: UILabel!
    @IBOutlet weak var isReportPublicBtn: UIButton!
    @IBOutlet weak var updateStatusBtn: UIButton!
    
    let reportService = ReportService()
    let uds = UserDefaults.standard
    
    var reportDelegate: ReportDelegate!
    var didUpdate = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initReportMapDetails()
        
        
        // Do any additional setup after loading the view.
    }


    @IBAction func dismiss(_ sender: UIButton) {
        reportDelegate.didReportUpdated(didUpdate: didUpdate)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onUpdateReportStatus(_ sender: Any) {
        self.updateStatusDialog()
    }
    
    @IBAction func onUpdateReportIsPublic(_ sender: Any) {
        self.updateIsPublicDialog()
    }
}

extension ViewMapReportVC {
    
    
    func initReportMapDetails() -> Void{
        
        let address = uds.string(forKey: report_address)
        let date = uds.string(forKey: report_created_at)
        let category = uds.string(forKey: report_category)
        var status = uds.string(forKey: report_status_detail_view)
        let message = uds.string(forKey: report_message)
        let imageUrls = uds.array(forKey: report_images) as? [String] ?? []
        
        let fname = uds.string(forKey: user_fname)
        let lname = uds.string(forKey: user_lname)
        let fullname = uds.string(forKey: report_reporter_username)
        let isPublic = uds.bool(forKey: report_is_public)
        let statusVal = uds.string(forKey: report_status_value)
        let reportTypeCode = uds.string(forKey: report_type_code)
        let reporterId = uds.string(forKey: report_reporter_id)
        
        self.reportIsPublic.text = isPublic ? NSLocalizedString("yes", comment: "") : NSLocalizedString("no", comment: "")
        self.location.text = address
        self.date.text = date?.toDate(format: nil)
        self.status.text = status
        self.notification.text = category
        self.message.text = message
        self.reportBy.text = fullname
        
        self.initImageViews(imageUrls: imageUrls)
        self.setStatusIndicator(status: statusVal)
        print("report map images: \(String(describing: imageUrls))")
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
            
        }
        else {
//            defaultDialog(vc: self, title: "Fetching images", message: "Image not found")
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
        
        let image = UIImageView(frame: CGRect(x: 0, y: yAxis, width: self.reportImageView.frame.width, height: 200))
        
        image.image = reportViewImage
        self.reportImageViewConstraint.constant = viewHeight
        self.reportImageView.autoresizesSubviews = true
        self.reportImageView.addSubview(image)
        self.reportImageView.clipsToBounds = true;
        
        print("view created")
        print("image height \(yAxis)")
        print("imageview height \(self.reportImageViewConstraint.constant)")
        
    }
    
    func setStatusIndicator (status: String?) {
        print("STATUS_: \(status)")
        switch status {
        case "NEW":
            self.reportStatusIndicator.image = UIImage(named: "status-new")
            self.reportStatusPin.image = UIImage(named: "pin-new")
        case "INPROGRESS":
            self.reportStatusIndicator.image = UIImage(named: "status-inprogress")
            self.reportStatusPin.image = UIImage(named: "pin-inprogress")
        case "DONE":
            self.reportStatusIndicator.image = UIImage(named: "status-done")
            self.reportStatusPin.image = UIImage(named: "pin-done")
        case "EXPIRED":
            self.reportStatusIndicator.image = UIImage(named: "status-new")
            self.reportStatusPin.image = UIImage(named: "pin-new")
        default:
            self.reportStatusIndicator.image = UIImage(named: "status-done")
            self.reportStatusPin.image = UIImage(named: "pin-done")
        }
    }
    
    func loadIsPublicInfo (code: String?) {
        print("REPORT_TYPE_CODE: \(code)")
        if code == "B" {
            self.reportIsPublic.isHidden = false
            self.isReportPublicLbl.isHidden = false
            self.isReportPublicBtn.isHidden = false
        } else {
            self.reportIsPublic.isHidden = true
            self.isReportPublicLbl.isHidden = true
            self.isReportPublicBtn.isHidden = true
            self.isReportPublicBtn.isEnabled = false
        }
    }
    
    func setBtnEnable (statusVal: String?, reporterId: String?, isPublic: Bool) {
        let user = UserModel()
        self.updateStatusBtn.isEnabled = statusVal == "NEW" || statusVal == "INPROGRESS"
        self.isReportPublicBtn.isEnabled = reporterId != nil && user.id != nil && reporterId == user.id && !isPublic
        
        if statusVal == "NEW" || statusVal == "INPROGRESS" {
            
        } else {
            self.updateStatusBtn.backgroundColor = UIColor.lightGray
            
        }
        
        if reporterId != nil && user.id != nil && reporterId == user.id && !isPublic {
            
        } else {
            self.isReportPublicBtn.backgroundColor = UIColor.lightGray
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
                    self.didUpdate = true
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
                    self.didUpdate = true
                    self.isReportPublicBtn.backgroundColor = UIColor.lightGray
                    self.isReportPublicBtn.isEnabled = false
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
