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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadBorderedVIew(viewContainer: ChooseCategView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: EmergencyView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: DescriptionView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: DescriptionTextView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: PersonalInvolvedView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: PersonsVehiclesView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: ImgUIView1, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: ImgUIView2, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: ImgUIView3, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.importImage(_:)))
        
        imgView1.isUserInteractionEnabled = true
        imgView2.isUserInteractionEnabled = true
        imgView3.isUserInteractionEnabled = true
        
        imgView1.addGestureRecognizer(gesture)
        //        imgView2.addGestureRecognizer(gesture)
        //        imgView3.addGestureRecognizer(gesture)
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
    
    @objc func tappedImageView() {
        print("tapped image view")
    }
    
    
    @objc func importImage (_ sender : UIImageView) {
        
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.photoLibrary
        img.allowsEditing = false
        
        self.present(img, animated: true, completion: nil)
        //        print("sender: \(sender.tag)")
    }
    
    
    
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
