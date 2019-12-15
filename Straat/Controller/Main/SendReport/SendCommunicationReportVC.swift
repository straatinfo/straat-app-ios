//
//  SendCommunicationReportVC.swift
//  Straat
//
//  Created by John Higgins M. Avila on 06/12/2019.
//

import UIKit
import iOSDropDown
import Photos
import UITextView_Placeholder

class SendCommunicationReportVC: UIViewController {
    
    @IBOutlet weak var mainCategView: UITextField!
    @IBOutlet weak var emergencyNotifView: UIButton!
    @IBOutlet weak var showInMapSwitch: UISwitch!
    @IBOutlet weak var reportDescriptionTxtBox: UITextView!
    
    @IBOutlet weak var photo1Img: UIImageView!
    @IBOutlet weak var photo2Img: UIImageView!
    @IBOutlet weak var photo3Img: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    var mapViewDelegate : MapViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
}
