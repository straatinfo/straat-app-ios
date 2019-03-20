//
//  RegistrationData.swift
//  Straat
//
//  Created by Global Array on 04/02/2019.
//

import UIKit
import Alamofire

class RegistrationDataVC: UIViewController {
    
    var postCode : String? = nil
    var postNumber : String? = nil
    var isMale : Bool? = true
    
    
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var firstnameTxtBox: UITextField!
    @IBOutlet weak var lastnameTxtBox: UITextField!
    @IBOutlet weak var usernameTxtBox: UITextField!
    @IBOutlet weak var userIdRand: UILabel!    
    @IBOutlet weak var termsAndCondition: UIButton!
    @IBOutlet weak var postCodeTxtBox: UITextField!
    @IBOutlet weak var postNumberTxtBox: UITextField!
    @IBOutlet weak var streetTxtBox: UITextField!
    @IBOutlet weak var townTxtBox: UITextField!
    @IBOutlet weak var emailTxtBox: UITextField!
    @IBOutlet weak var mobileNumberTxtBox: UITextField!
    @IBOutlet weak var passwordTxtBox: UITextField!
    @IBOutlet weak var nextStep: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userData = self.getInputs()
        self.loadInputs(userData: userData)
        self.initView()
        self.initKeyBoardToolBar()
    }
    

    @IBAction func selectedGender(_ sender: UIButton) {
        
        var buttonSelected: UIButton!
        
        // Conditional statement to identify the selected button
        // if has a tag 1 (Male) or 2 (female)
        if sender.tag == 1 {
            sender.isSelected = true
            buttonSelected = female
            isMale = true
            print("male")
        } else if sender.tag == 2{
            sender.isSelected = true
            buttonSelected = male
            isMale = false
            print("female")
        }

        diselect(sender: buttonSelected)
    }
    
    @IBAction func selectTAC(_ sender: Any) {
        let tacVC = storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionID") as! TermsAndConditionVC
        tacVC.acceptTACDele = self
        present(tacVC, animated: true, completion: nil)
    }
    
    @IBAction func onStep2Press(_ sender: Any) {
        self.goToStep2()
    }
    
    
    @IBAction func firstNameTextField(_ sender: UITextField) {
    }
    
    @IBAction func lastNameTextField(_ sender: UITextField) {
    }
    
    @IBAction func userNameTextField(_ sender: UITextField) {
    }
    
    @IBAction func getPostCode(_ sender: Any) {
        postCode = postCodeTxtBox.text
        if postNumber != nil {
            self.callPostCodeApi(postCode: postCode!, number: postNumber!){ (success, postalInfo, message) in
                if success == true {
                    self.townTxtBox.text = postalInfo.city
                    self.streetTxtBox.text = postalInfo.street
                }
            }
        }
    }
    
    @IBAction func sendPostNumber(_ sender: Any) {
        postNumber = postNumberTxtBox.text
        if postCode != nil {
            self.callPostCodeApi(postCode: postCode!, number: postNumber!){ (success, postalInfo, message) in
                if success == true {
                    self.townTxtBox.text = postalInfo.city
                    self.streetTxtBox.text = postalInfo.street
                }
            }
        }
    }
    
    @IBAction func emailTextField(_ sender: UITextField) {
    }
    
    @IBAction func mobileTextField(_ sender: UITextField) {
    }
    
    @IBAction func passwordTextField(_ sender: UITextField) {
    }
    @IBAction func userNameInfo(_ sender: UIButton) {
        defaultDialog(vc: self, title: "Username Info", message: "Please enter your username here. All other users can only see your username; your phone number, your name or other data is not shown.\n However, when you are member of a team, your team members will be able to see your real name, but not other data like your phonenumber. Your team coordinator can see all your data; with this (s)he can check if the right person is in the team.\n            When needed the police and other officials will be given access to your data.")
    }
}

//for input validations
extension RegistrationDataVC {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case usernameTxtBox:
            userIdRand.text =  "_ID:\(randomUserID())"
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        switch textField {
            case firstnameTxtBox:
                debugPrint("firstname")
                if textField.text?.isValid() ?? false {
                    checkTextFieldValues()
                } else {
                    firstnameTxtBox.becomeFirstResponder()
                    validationDialog(vc: self, title: "Wrong input", message: "Your firstname is not valid", buttonText: "Ok")
                    disableNextStepButton()
                }
            case lastnameTxtBox:
                debugPrint("lastname")
                if textField.text?.isValid() ?? false {
                    checkTextFieldValues()
                } else {
                    lastnameTxtBox.becomeFirstResponder()
                    validationDialog(vc: self, title: "Wrong input", message: "Your lastname is not valid", buttonText: "Ok")
                    disableNextStepButton()
                }
            case usernameTxtBox:
                debugPrint("username")
                if textField.text?.isValid() ?? false {
                    if textField.text?.isUserNameNotValid() ?? false {
                        validationDialog(vc: self, title: "Wrong input", message: "This username is already in use or not allowed. Please choose a different name.", buttonText: "Ok")
                    }
                    checkTextFieldValues()
                } else {
                    usernameTxtBox.becomeFirstResponder()
                    validationDialog(vc: self, title: "Wrong input", message: "Your usernmae is not valid", buttonText: "Ok")
                    disableNextStepButton()
                }
            case postCodeTxtBox:
                debugPrint("postal code")
                if textField.text?.isValid() ?? false {
                    checkTextFieldValues()
                } else {
                    postCodeTxtBox.becomeFirstResponder()
                    validationDialog(vc: self, title: "Wrong input", message: "Your lastname is not valid", buttonText: "Ok")
                    disableNextStepButton()
                }
            break
            case postNumberTxtBox:
                debugPrint("postal number")
                if textField.text?.isValid() ?? false {
                    checkTextFieldValues()
                } else {
                    postNumberTxtBox.becomeFirstResponder()
                    validationDialog(vc: self, title: "Wrong input", message: "Your post number is not valid", buttonText: "Ok")
                    disableNextStepButton()
                }
            case emailTxtBox:
                debugPrint("email")
                if textField.text?.isValidEmail() ?? false {
                    checkTextFieldValues()
                    debugPrint("valid email")
                } else {
                    emailTxtBox.becomeFirstResponder()
                    validationDialog(vc: self, title: "Wrong input", message: "Your e-mail is not valid", buttonText: "Ok")
                    disableNextStepButton()
                    debugPrint("not valid email")
                }
            case mobileNumberTxtBox:
                debugPrint("mobile")
                if textField.text?.isMobileNumberValid() ?? false {
                    checkTextFieldValues()
                } else {
                    validationDialog(vc: self, title: "Wrong input", message: "Your mobile number is not valid", buttonText: "Ok")
                    mobileNumberTxtBox.becomeFirstResponder()
                    disableNextStepButton()

                }
            case passwordTxtBox:
                debugPrint("pass")
                if textField.text?.isValidPassword() ?? false {
                    checkTextFieldValues()
                } else {
                    validationDialog(vc: self, title: "Wrong input", message: "Your password is not valid or must be atleast 6 characters", buttonText: "Ok")
                    passwordTxtBox.becomeFirstResponder()
                    disableNextStepButton()
                    debugPrint("not valid password")
                }
        default: break
        }
        
    }
    
    func disableNextStepButton() {
        self.nextStep.isEnabled = false
        self.nextStep.backgroundColor = UIColor.lightGray
    }
    
    func enableNextStepButton() {
        self.nextStep.isEnabled = true
        self.nextStep.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
        debugPrint("enable next step")
    }
    
    func checkTextFieldValues() {
        
        if self.textFieldHasValues(tf: [firstnameTxtBox, lastnameTxtBox, usernameTxtBox, postCodeTxtBox, postNumberTxtBox, streetTxtBox, townTxtBox, emailTxtBox, mobileNumberTxtBox, passwordTxtBox]) {
            enableNextStepButton()
        } else {
            disableNextStepButton()
        }
        
    }
    
    func textFieldHasValues (tf: [UITextField]) -> Bool {
        
        if validateTextField(tf: tf) {
            return true
        } else {
            return false
        }
    }
    
}

//for implementating delegate
extension RegistrationDataVC : acceptTACDelegate, UITextFieldDelegate, UITextViewDelegate {
    func state(state: Bool) {
        self.termsAndCondition.isSelected = state
        self.saveInputs() { (success, message) in
            print("Success: \(success), message: \(message)")
        }
        
        if state == true {
            enableNextStepButton()
        } else {
            disableNextStepButton()
        }
        print("state: \(state)" )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func initView() {
        self.streetTxtBox.isEnabled = false
        self.townTxtBox.isEnabled = false
        self.nextStep.isEnabled = false
        self.nextStep.backgroundColor = UIColor.lightGray
    }
    
    // initialise key board toolbar
    func initKeyBoardToolBar() -> Void {
        let kbToolBar = UIToolbar()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.keyBoardDismiss))

        kbToolBar.sizeToFit()
        kbToolBar.setItems([doneBtn], animated: false)
        
        self.mobileNumberTxtBox.inputAccessoryView = kbToolBar
        
    }
    
    // dismiss function of keyboard
    @objc func keyBoardDismiss() -> Void {
        view.endEditing(true)
    }
}


// for implementing functions
extension RegistrationDataVC {
    
    func diselect(sender: UIButton) {
        sender.isSelected = false
    }
    
    typealias OnFinish = ( Bool, PostalModel, String) -> Void

    func callPostCodeApi (postCode: String, number: String, completion: @escaping OnFinish) {
        let apiHandler = ApiHandler()
        
        let parameters = [
            "postcode": postCode,
            "number": number
        ]
        
        let headers = [
            "content-type": "application/json",
            "x-api-key": "gvuwmtomsB8eRf5Zgsfnj7zs8DE2ihC79DlEbQnb"
            ] as! HTTPHeaders
        
        loadingShow(vc: self)
        apiHandler.executeWithHeaders(URL(string: POST_CODE_API)!, parameters: parameters, method: .get, destination: .queryString, headers: headers) { (response, err) in
            
            if let error = err {
                print("error reponse: \(error.localizedDescription)")
                defaultDialog(vc: self, title: "Error Response", message: error.localizedDescription)
                // loadingDismiss()
                
            } else if let data = response {
                
                let dataObject = data["_embedded"] as? Dictionary <String, Any>
                
                let addresses = dataObject?["addresses"] as? [Dictionary<String, Any>]
                
                let postalData = addresses?[0]
                
                let postcode = postalData?["postcode"] as? String
                let municipality = postalData?["municipality"] as? String
                let city = postalData?["city"] as? Dictionary<String, Any>
                let cityLabel = city?["label"] as? String
                let street = postalData?["street"] as? String

                let postalInfo = PostalModel(postcode: postcode, municipality: municipality, city: cityLabel, street: street)
                
                completion(true, postalInfo, "Success")
                
                print("response:  \(String(describing: dataObject))")
                
            }
            loadingDismiss()
        }
    }
    
    func getInputs () -> UserRegistrationModel {
        let uds = UserDefaults.init()
        let prefix = "reg-user-data-"
        
        let gender = uds.object(forKey: prefix + "gender") as? String? ?? ""
        let fname = uds.object(forKey: prefix + "fname") as? String? ?? ""
        let lname = uds.object(forKey: prefix + "lname") as? String? ?? ""
        let username = uds.object(forKey: prefix + "username") as? String? ?? ""
        let userPrefix = uds.object(forKey: prefix + "userPrefix") as? String? ?? ""
        let postalCode = uds.object(forKey: prefix + "postalCode") as? String? ?? ""
        let postalNumber = uds.object(forKey: prefix + "postalNumber") as? String? ?? ""
        let street = uds.object(forKey: prefix + "street") as? String? ?? ""
        let town = uds.object(forKey: prefix + "town") as? String? ?? ""
        let email = uds.object(forKey: prefix + "email") as? String? ?? ""
        let phoneNumber = uds.object(forKey: prefix + "phoneNumber") as? String? ?? ""
        let password = uds.object(forKey: prefix + "password") as? String? ?? ""
        let tac = uds.object(forKey: prefix + "tac") as? Bool? ?? false
        
        let userData = UserRegistrationModel(gender: gender, firstname: fname, lastname: lname, username: username, userPrefix: userPrefix, postalCode: postalCode, postalNumber: postalNumber, street: street, town: town, email: email, phoneNumber: phoneNumber, password: password, tac: tac, isVolunteer: nil, hostId: nil, long: nil, lat: nil, team: nil)
        
        return userData
    }
    
    func loadInputs (userData: UserRegistrationModel) {
        firstnameTxtBox.text = userData.firstname ?? ""
        lastnameTxtBox.text = userData.lastname ?? ""
        usernameTxtBox.text = userData.username ?? ""
        userIdRand.text = userData.userPrefix ?? ""
        postCodeTxtBox.text = userData.postalCode ?? ""
        postNumberTxtBox.text = userData.postalNumber ?? ""
        streetTxtBox.text = userData.street ?? ""
        townTxtBox.text = userData.town ?? ""
        emailTxtBox.text = userData.email ?? ""
        passwordTxtBox.text = userData.password ?? ""
        mobileNumberTxtBox.text = userData.phoneNumber ?? ""
        
        self.termsAndCondition.isSelected = userData.tac ?? false
        let gender = userData.gender ?? "MALE"
        if gender == "MALE" {
            self.male.isSelected = true
            self.female.isSelected = false
            isMale = true
        } else if gender == "FEMALE" {
            self.male.isSelected = false
            self.female.isSelected = true
            isMale = false
        }
    }
    
    func saveInputs (completion: @escaping (Bool, String) -> Void) {
        var gender: String?
        if isMale == true {
            gender = "MALE"
        } else {
            gender = "FEMALE"
        }
        let fname = firstnameTxtBox.text ?? ""
        let lname = lastnameTxtBox.text ?? ""
        let username = usernameTxtBox.text ?? ""
        let userPrefix = userIdRand.text ?? ""
        let postalCode = postCodeTxtBox.text ?? ""
        let postalNumber = postNumberTxtBox.text ?? ""
        let street = streetTxtBox.text ?? ""
        let town = townTxtBox.text ?? ""
        let email = emailTxtBox.text ?? ""
        let phoneNumber = mobileNumberTxtBox.text ?? ""
        let password = passwordTxtBox.text ?? ""
        let tac = self.termsAndCondition.isSelected
        
        let tfs : [UITextField] = [firstnameTxtBox, lastnameTxtBox, usernameTxtBox, postCodeTxtBox, postNumberTxtBox, streetTxtBox, townTxtBox, emailTxtBox, mobileNumberTxtBox, passwordTxtBox]
        
        if validateTextField(tf: tfs) {
            let uds = UserDefaults.init()
            let prefix = "reg-user-data-"
            
            uds.set(gender, forKey: prefix + "gender")
            uds.set(fname, forKey: prefix + "fname")
            uds.set(lname, forKey: prefix + "lname")
            uds.set(username, forKey: prefix + "username")
            uds.set(userPrefix, forKey: prefix + "userPrefix")
            uds.set(postalCode, forKey: prefix + "postalCode")
            uds.set(postalNumber, forKey: prefix + "postalNumber")
            uds.set(street, forKey: prefix + "street")
            uds.set(town, forKey: prefix + "town")
            uds.set(email, forKey: prefix + "email")
            uds.set(phoneNumber, forKey: prefix + "phoneNumber")
            uds.set(password, forKey: prefix + "password")
            uds.set(tac, forKey: prefix + "tac")
            
            completion(true, "Success")
        } else {
            completion(false, "")
        }

    }
    
    func goToStep2 () -> Void {
        self.saveInputs() { (success, message) in
            if success == true {
                pushToNextVC(sbName: "Registration", controllerID: "step2VC", origin: self)
            } else {
                defaultDialog(vc: self, title: "Empty Fields", message: "Please fill up all the empty fields")
            }
        }
    }
    
}