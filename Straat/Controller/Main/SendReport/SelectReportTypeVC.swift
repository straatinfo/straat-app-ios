//
//  SelectReportTypeVC.swift
//  Straat
//
//  Created by Global Array on 09/02/2019.
//

import UIKit

class SelectReportTypeVC: UIViewController {

    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var infoSS: UIButton!
    @IBOutlet weak var infoPS: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadBorderedVIew(viewContainer: infoSS, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: infoPS, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))
        
        loadBorderedVIew(viewContainer: mainVIew, borderWidth: 1,
                         color: UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1))

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
