//
//  SelectReportVC.swift
//  Straat
//
//  Created by Global Array on 10/02/2019.
//

import UIKit

class SelectReportVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var infoSS: UIButton!    
    @IBOutlet weak var infoPS: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadBorderedVIew(viewContainer: infoSS, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: infoPS, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: mainView, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
