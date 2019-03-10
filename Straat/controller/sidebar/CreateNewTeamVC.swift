//
//  CreateTeamVC.swift
//  Straat
//
//  Created by Global Array on 02/03/2019.
//

import UIKit
import Photos
import Alamofire

class CreateNewTeamVC: UIViewController {

    var img : Data?
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamEmailAddress: UITextField!
    @IBOutlet weak var uploadTeamLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImageTapGestures()
        // Do any additional setup after loading the view.
    }

    @IBAction func createNewTeam(_ sender: UIButton) {
        let uds = UserDefaults.standard
        let userId = uds.string(forKey: user_id)

        
        loadingShow(vc: self)
        self.createTeam(userId: userId!) { (success, message) in
            loadingDismiss()
            defaultDialog(vc: self, title: "Creating New Team", message: message)

        }

    }
    
}

extension CreateNewTeamVC : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CreateNewTeamVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
            self.img = image.jpegData(compressionQuality: CGFloat.leastNormalMagnitude)!
            
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
    
    
    func createTeam (userId: String, completion: @escaping (Bool, String) -> Void) {
        
        let uds = UserDefaults.standard
        let hostId = uds.string(forKey: user_host_id)
        let isVolunteer = uds.string(forKey: user_is_volunteer)
        
        let apiHandler = ApiHandler()
        var parameters : Parameters = [:]

        parameters["_host"] = hostId ?? ""
        parameters["isVolunteer"] = isVolunteer ?? true
        parameters["teamName"] = self.teamName.text ?? ""
        parameters["teamEmail"] = self.teamEmailAddress.text ?? ""
        
        let url = URL(string: "https://straatinfo-backend-v2.herokuapp.com/v1/api/team/new/" + userId)
        
        apiHandler.executeMultiPart(url!, parameters: parameters, imageData: self.img, fileName: teamName.text!, photoFieldName: "team-logo", pathExtension: ".jpeg", method: .post, headers: [:]) { (response, err) in
            // go to main view
            completion(true, "Success")
        }
        
    }
    
}

