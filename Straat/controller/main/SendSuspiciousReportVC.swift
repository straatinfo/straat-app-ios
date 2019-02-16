//
//  SendReportVC.swift
//  Straat
//
//  Created by Global Array on 10/02/2019.
//

import UIKit

class SendSuspiciousReportVC: UIViewController {

    // UI Views
    @IBOutlet weak var MainContainer: UIView!
    @IBOutlet weak var ChooseCategView: UIView!
    @IBOutlet weak var EmergencyView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var DescriptionTextView: UIView!
    
    @IBOutlet weak var PersonsInvolvedView: UIView!
    @IBOutlet weak var PersonsInvolvedCountView: UIView!
    @IBOutlet weak var PersonsInvolvedDecriptionView: UIView!
    
    @IBOutlet weak var VehiclesInvolvedView: UIView!
    @IBOutlet weak var VehiclesInvolvedCountView: UIView!
    @IBOutlet weak var VehiclesInvolvedDescriptionView: UIView!
    
    
    @IBOutlet weak var ImgUIView1: UIView!
    @IBOutlet weak var ImgUIView2: UIView!
    @IBOutlet weak var ImgUIView3: UIView!
    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    
    @IBOutlet weak var emergencyNotifButton: UIButton!
    
    @IBOutlet weak var userLocation: UILabel!
    
    
    
    //constraints
    @IBOutlet weak var vehiclesConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadImageConstraint: NSLayoutConstraint!
    
    var selectedImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func emergencyNotifSelected(_ sender: UIButton) {

        if sender.isSelected {
            emergencyNotifButton.isSelected = false
        } else {
            emergencyNotifButton.isSelected = true
        }
        
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendRequest(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func personsInvolvedToggle(_ sender: UISwitch) {
        let personsInvolvedViews : [UIView] = [PersonsInvolvedCountView, PersonsInvolvedDecriptionView]
        if sender.isOn {
            self.viewAppearance(views: personsInvolvedViews, isHidden: false)
            self.vehiclesConstraint.constant = 20
        } else {
            self.viewAppearance(views: personsInvolvedViews, isHidden: true)
            self.vehiclesConstraint.constant = -265
        }
        animateLayout(view: self.view, timeInterval: 0.8)
    }
    
    @IBAction func vehiclesInvolvedToggle(_ sender: UISwitch) {

        let vehiclesInvolvedViews : [UIView] = [VehiclesInvolvedCountView, VehiclesInvolvedDescriptionView]
        
        if sender.isOn {
            self.viewAppearance(views: vehiclesInvolvedViews, isHidden: false)
            self.uploadImageConstraint.constant = 305
        } else {
            self.viewAppearance(views: vehiclesInvolvedViews, isHidden: true)
            self.uploadImageConstraint.constant = 20
        }
        
        animateLayout(view: self.view, timeInterval: 0.8)
    }
    
}


// for implementing function
extension SendSuspiciousReportVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // initialised default view
    func initView() -> Void {
        
        var views = [UIView]()
        var hideViews = [UIView]()
        
        views = [ChooseCategView, EmergencyView, DescriptionView, DescriptionTextView,
                 PersonsInvolvedView, PersonsInvolvedCountView, PersonsInvolvedDecriptionView, VehiclesInvolvedView, VehiclesInvolvedCountView, VehiclesInvolvedDescriptionView, ImgUIView1, ImgUIView2, ImgUIView3]
        
        hideViews = [PersonsInvolvedCountView, PersonsInvolvedDecriptionView, VehiclesInvolvedCountView, VehiclesInvolvedDescriptionView]

        self.setBorders(views: views)
        self.viewAppearance(views: hideViews, isHidden: true)
        self.setImageTapGestures()
        
        self.vehiclesConstraint.constant = -265
        self.uploadImageConstraint.constant = 20
        
        userLocation.text = UserDefaults.standard.string(forKey: "user_loc_address")
    }
    
    // setting tap gesture recognizer for imageview
    func setImageTapGestures() -> Void {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(_:)))
        
        imgView1.isUserInteractionEnabled = true
        imgView2.isUserInteractionEnabled = true
        imgView3.isUserInteractionEnabled = true
        
        imgView1.addGestureRecognizer(gesture)
        
    }
    
    // creating border for array of uiviews
    func setBorders(views : [UIView]) -> Void {
        for view in views {
            loadBorderedVIew(viewContainer: view, borderWidth: 1,
                             color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        }
    }
    
    // change appearance for array of uiviews
    func viewAppearance (views : [UIView], isHidden : Bool) -> Void {
        for view in views {
            view.isHidden = isHidden
        }
    }
    
    // import image via photo library
    @objc func importImage (_ sender : UIImageView) {
        
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.photoLibrary
        img.allowsEditing = false
    
        self.present(img, animated: true, completion: nil)
    }
    
    
    // getting user selected image via photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imgView1.image = image
            
        } else {
            print("importing img: error in uploading image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
}


