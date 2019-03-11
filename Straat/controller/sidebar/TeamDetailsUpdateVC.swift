//
//  TeamDetailsUpdateVC.swift
//  Straat
//
//  Created by Global Array on 01/03/2019.
//

import UIKit
import Photos
import Alamofire
import AlamofireImage

class TeamDetailsUpdateVC: UIViewController {

    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamEmail: UITextField!
    @IBOutlet weak var uploadTeamLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImageTapGestures()
        self.initView()
        // Do any additional setup after loading the view.
    }

}

extension TeamDetailsUpdateVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initView() {
        
        let uds = UserDefaults.standard
        let teamName = uds.string(forKey: team_name)
        let teamEmail = uds.string(forKey: team_email)
        let teamLogo = uds.string(forKey: team_logo)
        
        self.teamName.text = teamName
        self.teamEmail.text = teamEmail
        
        loadingShow(vc: self)
        
        if teamLogo != nil {
            self.getImage(imageUrl: teamLogo!) { (success, teamLogo) in
                if success == true {
                    self.uploadTeamLogo.image = teamLogo
                    loadingDismiss()
                }
            }
        } else {
            loadingDismiss()
        }

        
    }
    
    
    func getImage(imageUrl: String, completion: @escaping (Bool, UIImage?) -> Void) -> Void {
        
        Alamofire.request(URL(string: imageUrl)!).responseImage { response in
            
            if let img = response.result.value {
                completion(true, img)
            } else {
                completion(false, nil)
            }
        }
    }
    
}

extension TeamDetailsUpdateVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // setting tap gesture recognizer for imageview
    func setImageTapGestures() -> Void {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(gesture:)) )
        self.uploadTeamLogo.isUserInteractionEnabled = true
        self.uploadTeamLogo.addGestureRecognizer(gesture)
        
    }
    
    // import image via photo library
    @objc func importImage ( gesture : UITapGestureRecognizer) {
        
        let img = UIImagePickerController()
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
                    //                    defaultDialog(vc: self, title: "Permission denied", message: result)
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
            self.uploadTeamLogo.image = image
            
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
