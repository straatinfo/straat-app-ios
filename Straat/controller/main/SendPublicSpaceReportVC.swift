//
//  SendPublicSpaceReportVC.swift
//  Straat
//
//  Created by Global Array on 16/02/2019.
//

import UIKit
import iOSDropDown

class SendPublicSpaceReportVC: UIViewController {

    @IBOutlet weak var MainCategView: UIView!
    @IBOutlet weak var SubCategView: UIView!
    
    @IBOutlet weak var EmergencyView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var DescriptionTextView: UITextView!
    
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
    
    var selectedImageView : UIImageView!
    
    // dummy data
    var sampleArr : [String] = ["main categ 1", "main categ 2", "main categ 3", "main categ 4", "main categ 5", "main categ 6"]
    var sampleArr2 : [String] = ["sub categ 1", "sub categ 2", "sub categ 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
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
        
        views = [MainCategView, SubCategView, EmergencyView, DescriptionView,
                 DescriptionTextView, ImgUIView1, ImgUIView2, ImgUIView3]

        hideViews = [SubCategView]
        
        self.setBorders(views: views)
        self.viewAppearance(views: hideViews, isHidden: true)
        self.setImageTapGestures()
        self.loadMainCategDropDown(mainCategList: self.sampleArr)
        
        self.emergencyNotifConstraint.constant = -150
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
    
    // populate main categ list data to dropdown
    func loadMainCategDropDown(mainCategList : [String]!) {
        
        mainCategDropDown.optionArray = mainCategList
        mainCategDropDown.selectedRowColor = UIColor.lightGray
        
        mainCategDropDown.didSelect { (selectedItem, index, id) in
            print("selectedItem: \(selectedItem)" )
            // insert code to identify the main category item if it has
            // sub category then show sub categ dropdown

            //code for appearing sub categ
            let showViews : [UIView] = [self.SubCategView]
            self.viewAppearance(views: showViews, isHidden: false)
            self.loadsubCategDropDown(subCategList: self.sampleArr2)
            self.emergencyNotifConstraint.constant = 20
            animateLayout(view: self.view, timeInterval: 0.8)
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
