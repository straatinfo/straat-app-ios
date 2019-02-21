//
//  SendPublicSpaceReportVC.swift
//  Straat
//
//  Created by Global Array on 16/02/2019.
//

import UIKit
import iOSDropDown
import Photos

class SendPublicSpaceReportVC: UIViewController {

    @IBOutlet weak var MainCategView: UIView!
    @IBOutlet weak var SubCategView: UIView!
    
    @IBOutlet weak var EmergencyView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var DescriptionTextView: UIView!
    
    @IBOutlet weak var ImgUIView1: UIView!
    @IBOutlet weak var ImgUIView2: UIView!
    @IBOutlet weak var ImgUIView3: UIView!
    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    
    @IBOutlet weak var emergencyNotifButton: UIButton!
    
    @IBOutlet weak var userLocation: UILabel!
    

    @IBOutlet weak var mainCategDropDown: DropDown!
    @IBOutlet weak var subCategDropDown: DropDown!
    
    @IBOutlet weak var emergencyNotifConstraint: NSLayoutConstraint!
    

    //image view tags
    var imgViewTag : Int!
    
    // dummy data
    var sampleArr : [String] = ["main categ 1", "main categ 2", "main categ 3", "main categ 4", "main categ 5", "main categ 6"]
    var sampleArr2 : [String] = ["sub categ 1", "sub categ 2", "sub categ 3"]
    
    
    var mainCategoryName = [String]() // for dropdown
    var subCategory = [SubCategoryModel]()
    var subCategoryName = [String]() // for dropdown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initCategories()
    }
    
    @IBAction func emergencyNotif(_ sender: UIButton) {
        if sender.isSelected {
            emergencyNotifButton.isSelected = false
        } else {
            emergencyNotifButton.isSelected = true
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendReport(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}










// for implement functions
extension SendPublicSpaceReportVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // initialised default view
    func initView() -> Void {
        
        var views = [UIView]()
        var hideViews = [UIView]()
        
        views = [MainCategView, SubCategView, EmergencyView, DescriptionView, DescriptionTextView, ImgUIView1, ImgUIView2, ImgUIView3]

        hideViews = [SubCategView]
        
        self.setBorders(views: views)
        self.viewAppearance(views: hideViews, isHidden: true)
        self.setImageTapGestures()
        
        self.emergencyNotifConstraint.constant = -150
        userLocation.text = UserDefaults.standard.string(forKey: "user_loc_address")
    }
    
    func initCategories() -> Void {
        
        let categoryService = CategoryService()
        
        categoryService.getMainCategoryA(hostId: "5a7b485a039e2860cf9dd19a", language: "nl") { (success, message, mainCategories) in
            if success == true {

                
                for mainCategory in mainCategories {
                    let mainCateg : MainCategoryModel = mainCategory
                    let name = mainCateg.name!
                    
                    self.mainCategoryName.append(name)
                    self.subCategory = mainCateg.subCategories

//                    if mainCateg.subCategories.count > 0 {
//                        for subCateg in mainCateg.subCategories {
//                            self.extractSubCategory(subCateg: self.subCategory, categoryName: name )
//                        }
//                    }
                    
//                    print("MAIN CAT", mainCateg.name!)
                }
                
                self.loadMainCategDropDown(mainCategList: self.mainCategoryName, subCategories: self.subCategory)
                
            }
        }
        
        //        categoryService.getMainCategoryB(language: "nl") { (success, message, mainCategories) in
        //            if success == true {
        //                print("MAIN CAT B", mainCategories)
        //            }
        //        }
    }
    
    func extractSubCategory (subCateg : SubCategoryModel , categoryName : String) {
        print("main categ: \(categoryName) => sub category: \(String(describing: subCateg.name))")
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
//                    defaultDialog(vc: self, title: "Permission denied", message: result)
                    print("permission \(result)")
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
                defaultDialog(vc: self, title: "Import Image", message: "Error occured when importing image")
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
    func loadMainCategDropDown(mainCategList : [String]! , subCategories : [SubCategoryModel]!) {
        
        mainCategDropDown.optionArray = mainCategList
        mainCategDropDown.selectedRowColor = UIColor.lightGray
        
        mainCategDropDown.didSelect { (selectedItem, index, id) in
            print("selectedItem: \(selectedItem)" )
            // insert code to identify the main category item if it has
            // sub category then show sub categ dropdown
            
            self.subCategoryName.removeAll()
            for checkSubCateg in subCategories {
                if selectedItem == checkSubCateg.mainCategoryName! {
                    self.subCategoryName.append(checkSubCateg.name!)
                    print("meron sub categ")
                } else {
                    print("wala sub categ")
                }
                print("sub categ -> main categ name: \(String(describing: checkSubCateg.mainCategoryName))")
            }

            let showViews : [UIView] = [self.SubCategView]
            
            if self.subCategoryName.count > 0 {
                //code for appearing sub categ
                self.viewAppearance(views: showViews, isHidden: false)
                self.loadsubCategDropDown(subCategList: self.subCategoryName)
                self.emergencyNotifConstraint.constant = 20
                animateLayout(view: self.view, timeInterval: 0.8)
            } else {
                self.viewAppearance(views: showViews, isHidden: true)
                self.emergencyNotifConstraint.constant = -150
                animateLayout(view: self.view, timeInterval: 0.8)
            }

        }
    }
    
    
    
    // populate main categ list data to dropdown
    func loadsubCategDropDown(subCategList : [String]!) {
        
        subCategDropDown.optionArray = subCategList
        subCategDropDown.selectedRowColor = UIColor.lightGray
        subCategDropDown.didSelect { (selectedItem, index, id) in
            print("selectedItem: \(selectedItem)" )
        }
    }
    
    
}
