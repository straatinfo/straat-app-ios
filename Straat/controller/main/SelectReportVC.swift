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

        var views : [UIView]
        views = [infoSS, infoPS, mainView]
        
        self.setBorders(views: views)
        
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension SelectReportVC {

    // creating border for array of uiviews
    func setBorders(views : [UIView]) -> Void {
        for view in views {
            loadBorderedVIew(viewContainer: view, borderWidth: 1,
                             color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        }
    }

}
