//
//  ProfileVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit
import Photos

class ProfileVC: UIViewController {
    
    var didUpdate = false
    var userService = UserService()
    var profilePic: Data?

    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var familyName: UITextField!
    @IBOutlet weak var addressLotNum: UITextField!
    @IBOutlet weak var addressPostalCode: UITextField!
    @IBOutlet weak var addedStreet: UITextField!
    @IBOutlet weak var addedTown: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var chatName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var uploadImage: UIImageView!
    
    // MARK: Input text listeners
    
    
    
    @IBAction func fnameEdit(_ sender: Any) {
        self.wasUpdated()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()
        self.setImageTapGestures()
        self.loadProfileData()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func changeMyDataClicked(_ sender: Any) {
        if !self.didUpdate {
            defaultDialog(vc: self, title: "Warning", message: "No Changes")
        } else {
            if profilePic != nil {
                self.updateProfilePic() { (success, text) in
                    if success {
                        self.updateProfile() { (success, text) in
                            if success {
                                defaultDialog(vc: self, title: "Update profile", message: "Successfully updated your profile")
                            } else {
                                defaultDialog(vc: self, title: "Update profile", message: "An error occured please try again.")
                            }
                        }
                    } else {
                        defaultDialog(vc: self, title: "Update profile", message: "An error occured please try again.")
                    }
                }
            } else {
                self.updateProfile() { (success, text) in
                    if success {
                        defaultDialog(vc: self, title: "Update profile", message: "Successfully updated your profile")
                    } else {
                        defaultDialog(vc: self, title: "Update profile", message: "An error occured please try again.")
                    }
                }
            }
        }
    }
    
}

extension ProfileVC : UITextFieldDelegate {
    
    // for revealing side bar menu
    func createMenu() -> Void {
        if revealViewController() != nil {
            
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = UIScreen.main.bounds.size.width - 100
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        } else {
            print("problem in SWRVC")
        }
    }
    
    // setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Straat.info"
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension ProfileVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // setting tap gesture recognizer for imageview
    func setImageTapGestures() -> Void {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        
        self.uploadImage.isUserInteractionEnabled = true
        self.uploadImage.layer.cornerRadius = 50
        self.uploadImage.addGestureRecognizer(gesture)

        
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
            self.uploadImage.image = image
            self.profilePic = image.jpegData(compressionQuality: CGFloat.leastNormalMagnitude)!
            didUpdate = true
            
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
    
}


// MARK Custom functions
extension ProfileVC {
    func wasUpdated () {
        self.didUpdate = true
    }
    
    func loadProfileData () {
        let u = UserModel()
        self.firstName.text = u.getDataFromUSD(key: user_fname)
        self.familyName.text = u.getDataFromUSD(key: user_lname)
        self.addressLotNum.text = u.getDataFromUSD(key: user_house_number)
        self.addressPostalCode.text = u.getDataFromUSD(key: user_postal_code)
        self.addedStreet.text = u.getDataFromUSD(key: user_street_name)
        self.addedTown.text = u.getDataFromUSD(key: user_city)
        self.contactEmail.text = u.getDataFromUSD(key: user_email)
        self.contactNumber.text = u.getDataFromUSD(key: user_phone_number)
        self.chatName.text = u.getDataFromUSD(key: user_username)
        // self.password.text = u.getDataFromUSD(key: user_fname)
        // self.uploadImage.text = u.getDataFromUSD(key: user_fname)
    }
    
    func getUpdatedProfileData () -> Dictionary<String, Any> {
        var data = Dictionary<String, Any>()
        data["fname"] = self.firstName.text ?? ""
        data["lname"] = self.familyName.text ?? ""
        data["email"] = self.contactEmail.text ?? ""
        data["username"] = self.chatName.text ?? ""
        data["houseNumber"] = self.addressLotNum.text ?? ""
        data["postalCode"] = self.addressPostalCode.text ?? ""
        data["streetName"] = self.addedStreet.text ?? ""
        data["city"] = self.addedTown.text ?? ""
        data["phoneNumber"] = self.contactNumber.text ?? ""
        
        
        return data
    }
    
    func updateProfile (completion: @escaping (Bool, String) -> Void) {
        
        let u = UserModel()
        let userId = u.getDataFromUSD(key: user_id)
        let userInput = self.getUpdatedProfileData()
        self.userService.updateUserDetails(userId: userId, userInput: userInput) {
            (success, text) in
            
            if success {
                var userData = userInput
                userData["gender"] = u.getDataFromUSD(key: user_gender)
                userData["_id"] = u.getDataFromUSD(key: user_id)
                
                let updateUser = UserModel(fromLogin: userData)
                updateUser.saveToLocalData()
            }
            
            completion(success, text)
        }
    }
    
    func updateProfilePic (completion: @escaping (Bool, String) -> Void) {
        let u = UserModel()
        let userId = u.getDataFromUSD(key: user_id)
        if profilePic != nil {
            userService.uploadProfilPic(userId: userId, image: profilePic!) { (success, text) in
                
               completion(success, text)
            }
        }
    }
}
