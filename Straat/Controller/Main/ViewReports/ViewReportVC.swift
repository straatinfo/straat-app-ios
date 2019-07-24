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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initReportMapDetails()
        // Do any additional setup after loading the view.
    }
    
}

extension ViewReportVC {
    
    
    func initReportMapDetails() -> Void{
        let uds = UserDefaults.standard

        let address = uds.string(forKey: report_address)
        let date = uds.string(forKey: report_created_at)
        let category = uds.string(forKey: report_category)
        let status = uds.string(forKey: report_status_detail_view)
        let message = uds.string(forKey: report_message)
        let imageUrls = uds.array(forKey: report_images) as! [String]
        
//        let fname = uds.string(forKey: user_fname)
//        let lname = uds.string(forKey: user_lname)
        let fullname = uds.string(forKey: report_reporter_fullname)
        let reporterUsername = uds.string(forKey: report_reporter_username)
        
        self.location.text = address
        self.date.text = date
        self.status.text = status
        self.mainCategoryName.text = category
        self.message.text = message
        self.reportedBy.text = reporterUsername
        
        self.initImageViews(imageUrls: imageUrls)
        print("report fullname: \(String(describing: fullname))")
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
    
}
