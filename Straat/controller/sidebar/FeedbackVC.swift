//
//  FeedbackVC.swift
//  Straat
//
//  Created by Global Array on 22/02/2019.
//

import UIKit

class FeedbackVC: UIViewController {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var textInput: UITextView!
    
    let userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createMenu()
        self.navColor()
        self.initKeyBoardToolBar()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitFeedback(_ sender: Any) {
        loadingShow(vc: self)
        let uds = UserDefaults.standard;
        let name = nameInput.text ?? ""
        let email = emailInput.text ?? ""
        let feedback = textInput.text ?? ""
        let reporterId = uds.string(forKey: user_id)
        
        self.sendFeedback(reporterId: reporterId!, name: name, email: email, feedback: feedback) { (success, text) in
            loadingDismiss()
            if success {
                self.nameInput.text = ""
                self.emailInput.text = ""
                self.textInput.text = ""
                defaultDialog(vc: self, title: "Success", message: "Successfully sent feedback")
            } else {
                defaultDialog(vc: self, title: "Failed", message: "Unable to send feedback")
            }
            
        }
    }
    
    
}

extension FeedbackVC : UITextFieldDelegate {
    
    // for revealing side bar menu
    func createMenu() -> Void {
        if revealViewController() != nil {
            
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = UIScreen.main.bounds.size.width - 100
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        } else {
            print("problem in SWRVC")
        }
    }
    
    // setting navigation bar colors
    func navColor() -> Void {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 79 / 255, green: 106 / 255, blue: 133 / 255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = "Straat.info"
    }
    
    // initialise key board toolbar
    func initKeyBoardToolBar() -> Void {
        let kbToolBar = UIToolbar()
        kbToolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.keyBoardDismiss))
        
        kbToolBar.setItems([doneBtn], animated: false)
        
        self.textInput.inputAccessoryView = kbToolBar
        
    }
    
    // dismiss function of keyboard
    @objc func keyBoardDismiss() -> Void {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension FeedbackVC {
    // custom functions
    func sendFeedback (reporterId: String, name: String, email: String, feedback: String, completion: @escaping (Bool, String) -> Void) {
        
        
        self.userService.sendFeedback(reporterId: reporterId, reporterName: name, reporterEmail: email, feedback: feedback, info: "") { (success, message) in
            
            
            if success {
                completion(true, "Success")
            } else {
                completion(false, "Failed")
            }
        }
    }
}
