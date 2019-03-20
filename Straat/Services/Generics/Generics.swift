//
//  Loading.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation
import UIKit
import GameplayKit

    var activityIndicator: UIActivityIndicatorView?
    var parentView = UIView()

    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let loadingLabel = UILabel(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: 20))

    // show loading
    func loadingShow(vc : UIViewController) {
        
        activityIndicator = UIActivityIndicatorView()
        //    activityIndicator!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        parentView = vc.view
        
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 10
        view.alpha = 0.5
        view.tag = 101
        
        loadingLabel.text = "Please Wait"
        loadingLabel.textColor = UIColor.white
        loadingLabel.font = loadingLabel.font.withSize(15)
        loadingLabel.textAlignment = .center
        
        activityIndicator!.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator!.center = view.center
        activityIndicator!.hidesWhenStopped = true
        activityIndicator!.style = UIActivityIndicatorView.Style.white
        activityIndicator!.isUserInteractionEnabled = false
        
        view.addSubview(activityIndicator!)
        view.addSubview(loadingLabel)
        vc.view.addSubview(view)
        view.center = vc.view.center
        
        activityIndicator!.startAnimating()        
    }

    // dismiss loading
    func loadingDismiss() {
        
        if let removeViewTag = parentView.viewWithTag(101) {
            activityIndicator!.stopAnimating()
            activityIndicator!.removeFromSuperview()
            activityIndicator!.willRemoveSubview(view)
            activityIndicator = nil
            removeViewTag.removeFromSuperview()
        }
    }


    // show dialog with default parameters
    func defaultDialog( vc: UIViewController, title : String? , message : String? ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        vc.present(alertController, animated: true)
        
    }

    func validationDialog( vc: UIViewController, title : String? , message : String? , buttonText: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
        vc.present(alertController, animated: true)
        
    }


    // pushing to next view controller
    func pushToNextVC( sbName : String? , controllerID : String?, origin :  UIViewController ) {
        
        let sb : UIStoryboard = UIStoryboard(name: sbName!, bundle: nil)
        let mainVC = sb.instantiateViewController(withIdentifier: controllerID!)
        
        origin.present(mainVC, animated: true, completion: nil)
        
    }
    
    // creates borders lines of container
    func loadBorderedVIew( viewContainer : UIView , borderWidth : CGFloat , color : UIColor) {
        viewContainer.layer.borderWidth = borderWidth
        viewContainer.layer.borderColor = color.cgColor
        
    }

    //animates layout
    func animateLayout (view : UIView , timeInterval : TimeInterval) {
        UIView.animate(withDuration: timeInterval) {
            view.layoutIfNeeded()
        }
    }

    func randomUserID() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<5).map{ _ in letters.randomElement()! })
    }

    protocol MapViewDelegate {
        func refresh() -> Void
    }


    extension UITextField {
        func loadDropdownData(data: [String]) {
            self.inputView = MyPickerView(pickerData: data, dropdownField: self)
        }
        
        func loadDropdownData2(data: [String]) {
            self.inputView = MyPickerView(pickerData: data, dropdownField: self)
        }
        
        func loadDropdownData3(data: [String]) {
            self.inputView = MyPickerView(pickerData: data, dropdownField: self)
        }
        
//        func loadMainCategoryB(mainCategList : [String] , subCategories : [[SubCategoryModel]], type: String) {
//
//        }
    }
