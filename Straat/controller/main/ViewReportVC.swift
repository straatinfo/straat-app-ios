//
//  ViewReport.swift
//  Straat
//
//  Created by Global Array on 18/02/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewReportVC: UIViewController {

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

extension ViewReportVC {
    
    // initialise report mat details
    func initReportMapDetails() -> Void{
        let uds = UserDefaults.standard

        let category = uds.string(forKey: "report-category")
        let status = uds.string(forKey: "report-status")
        let message = uds.string(forKey: "report-message")
        let address = uds.string(forKey: "report-address")
        let imageUrls = uds.array(forKey: "report-images") as! [String]
        
        self.location.text = address
        self.status.text = status
        self.notification.text = category
        self.message.text = message
    
        self.initImageViews(imageUrls: imageUrls)
        print("report images: \(String(describing: imageUrls))")
    }
    
    // initialise report images
    func initImageViews(imageUrls : [String]) -> Void {
 
        loadingShow(vc: self)
        
        if imageUrls.count > 0 {

            self.getReportImageFromUrl(imageUrls: imageUrls) { (hasImage, images, yAxis, viewHeight) in
                if hasImage {
                    self.setImageViews(reportViewImage: images!, yAxis: yAxis, viewHeight: viewHeight)
                } else {
                    defaultDialog(vc: self, title: "Fetching image", message: "No Image")
                }
                loadingDismiss()
            }

        }
        
    }
    
    // fetching report image from secured url
    func getReportImageFromUrl (imageUrls : [String], completion: @escaping (Bool, UIImage?, CGFloat, CGFloat) -> Void) -> Void {

        var yAxis : CGFloat = 0
        var viewHeight : CGFloat = 205
        
        for imageUrl in imageUrls {

            Alamofire.request(URL(string: imageUrl)!).responseImage { response in
                
                if let img = response.result.value {
                    print("report image downloaded: \(img)")
                    
                    DispatchQueue.main.async {
                            completion(true, img, yAxis, viewHeight)
                            yAxis += 205
                            viewHeight += yAxis
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
        self.reportImageViewConstraint.constant += viewHeight
        self.reportImageView.autoresizesSubviews = true
        self.reportImageView.addSubview(image)
        
        self.reportImageView.clipsToBounds = true;
        print("view created")
        print("imageview height \(self.reportImageViewConstraint.constant)")

    }
    
}
