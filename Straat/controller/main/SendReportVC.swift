//
//  SendReport.swift
//  Straat
//
//  Created by Global Array on 03/02/2019.
//

import UIKit

class SendReportVC: UIViewController {

    @IBOutlet weak var ChooseCategView: UIView!
    @IBOutlet weak var EmergencyView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var DescriptionTextView: UIView!
    @IBOutlet weak var PersonalInvolvedView: UIView!
    @IBOutlet weak var PersonsVehiclesView: UIView!
    
    @IBOutlet weak var ImgUIView1: UIView!
    @IBOutlet weak var ImgUIView2: UIView!
    @IBOutlet weak var ImgUIView3: UIView!
    
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    
    var imgViewTag : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultView()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}


extension SendReportVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // executing default view of registration team section
    func defaultView() {

        var uiViews = [UIView]()
        uiViews = [ChooseCategView, EmergencyView, DescriptionView, DescriptionTextView, PersonalInvolvedView, PersonsVehiclesView, ImgUIView1, ImgUIView2, ImgUIView3]
        
        for view in uiViews {
            loadBorderedVIew(viewContainer: view, borderWidth: 1,
                             color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        }
        
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
    
    @objc func tappedImageView() {
        print("tapped image view")
    }
    
    
    @objc func importImage ( gesture : UITapGestureRecognizer) {
        
        let img = UIImagePickerController()
        let view = gesture.view!
        let tag = view.tag
        
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.photoLibrary
        img.allowsEditing = false
        
        self.present(img, animated: true, completion: nil)
        self.imgViewTag = tag
    }
    
    
    
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
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
