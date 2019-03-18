//
//  ViewReport.swift
//  Straat
//
//  Created by Global Array on 18/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initReportMapDetails()
        // Do any additional setup after loading the view.
    }


    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewMapReportVC {
    
    
    func initReportMapDetails() -> Void{
        let uds = UserDefaults.standard
        
        let address = uds.string(forKey: report_address)
        let date = uds.string(forKey: report_created_at)
        let category = uds.string(forKey: report_category)
        let status = uds.string(forKey: report_status_detail_view)
        let message = uds.string(forKey: report_message)
        let imageUrls = uds.array(forKey: report_images) as! [String]
        
        let fname = uds.string(forKey: user_fname)
        let lname = uds.string(forKey: user_lname)
        let fullname = fname! + " " + lname!
        
        self.location.text = address
        self.date.text = date
        self.status.text = status
        self.notification.text = category
        self.message.text = message
        self.reportBy.text = fullname
        
        self.initImageViews(imageUrls: imageUrls)
        print("report map images: \(String(describing: imageUrls))")
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
//        else {
//            defaultDialog(vc: self, title: "Fetching images", message: "Image not found")
//            loadingDismiss()
//        }
        
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
    
}
