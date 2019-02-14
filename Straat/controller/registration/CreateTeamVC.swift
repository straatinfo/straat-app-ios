//
//  CreateTeamVC.swift
//  Straat
//
//  Created by Global Array on 10/02/2019.
//

import UIKit
import iOSDropDown

class CreateTeamVC: UIViewController {

    @IBOutlet weak var imageTeamLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func importTeamLogo(_ sender: UIButton) {
        importImage()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

// for implementing functions
extension CreateTeamVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func importImage () {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.photoLibrary
        img.allowsEditing = false
        
        self.present(img, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageTeamLogo.image = image
            
        } else {
            print("importing img: error in uploading image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
