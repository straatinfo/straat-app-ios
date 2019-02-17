//
//  SendReportVC.swift
//  Straat
//
//  Created by Global Array on 10/02/2019.
//

import UIKit
import Photos
import iOSDropDown

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
    @IBOutlet weak var mainCategDropDown: DropDown!
    
    //dummy data for category
    var sampleArr : [String] = ["main categ 1", "main categ 2", "main categ 3", "main categ 4", "main categ 5", "main categ 6"]
    
    //constraints
    @IBOutlet weak var vehiclesConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadImageConstraint: NSLayoutConstraint!
    
    //image view tags
    var imgViewTag : Int!

    
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
        self.loadMainCategDropDown(mainCategList: sampleArr)
        
        self.vehiclesConstraint.constant = -265
        self.uploadImageConstraint.constant = 20
        
        userLocation.text = UserDefaults.standard.string(forKey: "user_loc_address")
        
    }
    
    // setting tap gesture recognizer for imageview
    func setImageTapGestures() -> Void {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        
        imgView1.isUserInteractionEnabled = true
        imgView2.isUserInteractionEnabled = true
        imgView3.isUserInteractionEnabled = true
        
        imgView1.addGestureRecognizer(gesture)
        imgView2.addGestureRecognizer(gesture2)
        imgView3.addGestureRecognizer(gesture3)
        
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
    @objc func importImage ( gesture : UITapGestureRecognizer) {
        
        let img = UIImagePickerController()
        let view = gesture.view!
        img.delegate = self
        
        let alert = UIAlertController(title: "Image Source", message: "Please choose where to take your image", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            //some shitty code
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                img.sourceType = UIImagePickerController.SourceType.camera
                self.present(img, animated: true, completion: nil)
                self.imgViewTag = view.tag
            } else {
                defaultDialog(vc: self, title: "Camera not available", message: nil)
            }

        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            //some shitty code
            
            self.importImagePermission { (hasGranted, result) in
                
                if hasGranted {
                    img.sourceType = UIImagePickerController.SourceType.photoLibrary
                    img.allowsEditing = false
                    
                    self.present(img, animated: true, completion: nil)
                    self.imgViewTag = view.tag
                } else {
                    defaultDialog(vc: self, title: "Permission denied", message: result)
                }
                
            }

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // getting user selected image via photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            switch(self.imgViewTag) {
                
            case 1:
                imgView1.image = image
                break;
            case 2:
                imgView2.image = image
                break;
            case 3:
                imgView3.image = image
                break
            default:
                print("error in importing image")
                break
            }
            
        } else {
            print("importing img: error in uploading image")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //photo library image permission
    func importImagePermission( completion: @escaping (Bool , String?) -> Void) -> Void {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
            case .authorized:
                completion(true, "Access granted")
                print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                        case .authorized:
                            completion(true, "Access granted")
                        
                        case .denied:
                            completion(false, "User has denied the permission.")

                        case .restricted:
                            completion(false, "User do not have access to photo album.")

                        case .notDetermined:
                            completion(false, "It is not determined until now")

                    }
                }
                
                completion(false, "It is not determined until now")
                print("It is not determined until now")
            
            case .restricted:
                // same same
                completion(false, "User do not have access to photo album.")
                print("User do not have access to photo album.")
            
            case .denied:
                // same same
                completion(false, "User has denied the permission.")
                print("User has denied the permission.")
            
            
        }
        

    }
    
    // populate main categ list data to dropdown
    func loadMainCategDropDown(mainCategList : [String]!) {
        
        mainCategDropDown.optionArray = mainCategList
        mainCategDropDown.selectedRowColor = UIColor.lightGray
        
        mainCategDropDown.didSelect { (selectedItem, index, id) in
            print("selectedItem: \(selectedItem)" )
            // insert code to identify the main category item if it has
            // sub category then show sub categ dropdown
            
            //code for appearing sub categ
        }
    }

    
}


