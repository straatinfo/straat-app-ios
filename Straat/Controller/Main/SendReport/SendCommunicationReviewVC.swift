//
//  SendCommunicationReviewVC.swift
//  Straat
//
//  Created by Global Array on 20/12/2019.
//

import UIKit

class SendCommunicationReviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func btnBack(_ sender: UIButton) {
		pushToNextVC(sbName: "Main", controllerID: "SendCommunicationTeamsVC", origin: self)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
