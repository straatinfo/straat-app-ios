//
//  EnterCode.swift
//  Straat
//
//  Created by Global Array on 29/01/2019.
//

import Foundation
import UIKit
import Alamofire

class EnterCodeVC: UIViewController {
    
    @IBOutlet weak var tfCode: UITextField!
    let apiHandler = ApiHandler()
    
    override func viewDidLoad() {
            //some shit code
    }
    
    @IBAction func btnOkay(_ sender: UIButton) {
        
        let tf : [UITextField] = [tfCode]
        
        if validateTextField(tf: tf) {

            loadingShow(vc: self)
            code(params: [ "code" : tfCode.text! ])
            
            
            print("code: " + tfCode.text!)
        } else {
            // creates an alert for this result
            defaultDialog(vc: self, title: "Enter Code", message: "Please fill up all the empty fields")
        }
        
    }
    
    
    func code( params : Parameters ) {
        
        apiHandler.execute(URL(string: request_host)!, parameters: params, method: .post, destination: .httpBody) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                loadingDismiss()
                // creates an alert for this error response
                
            } else if let data = response {
                
                loadingDismiss()
                
                let dataObject = data["data"] as? Dictionary <String, Any>
//                let userObject = dataObject?["user"] as? Dictionary <String, Any>
                
                print("response:  \(String(describing: dataObject))")

                //saving user model to loca data
//                self.saveToLocalData()
//                self.pushToNextVC()
                
            }
            
        }
        
    }
    
    
    
}
