//
//  SendReportVC.swift
//  Straat
//
//  Created by Global Array on 10/02/2019.
//

import UIKit

class SendReportVC: UIViewController {

    
    @IBOutlet weak var ChooseCategView: UIView!
    @IBOutlet weak var EmergencyView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var DescriptionTextView: UIView!
    @IBOutlet weak var PersonalInvolvedView: UIView!
    @IBOutlet weak var PersonsVehiclesView: UIView!
    
    @IBOutlet weak var ImgView1: UIView!
    @IBOutlet weak var ImgView2: UIView!
    @IBOutlet weak var ImgView3: UIView!
    
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
        
        loadBorderedVIew(viewContainer: ImgView1, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: ImgView2, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: ImgView3, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func sendRequest(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
