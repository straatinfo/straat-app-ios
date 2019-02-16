//
//  Loading.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation
import UIKit


    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    // show loading
    func loadingShow(vc : UIViewController) {
        
        //    activityIndicator = UIActivityIndicatorView(frame: alertController.view.bounds)
        //    activityIndicator!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        activityIndicator.center = vc.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.isUserInteractionEnabled = false
        
        vc.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        //    vc.present(alertController, animated: true)
        
    }

    // dismiss loading
    func loadingDismiss() {
        
        activityIndicator.stopAnimating()
        //    alertController.dismiss(animated: true, completion: nil)
        
    }


    // show dialog with default parameters
    func defaultDialog( vc: UIViewController, title : String? , message : String? ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        vc.present(alertController, animated: true)
        
    }

    // pushing to next view controller
    func pushToNextVC( sbName : String? , controllerID : String?, origin :  UIViewController ) {
        
        let sb : UIStoryboard = UIStoryboard(name: sbName!, bundle: nil)
        let mainVC = sb.instantiateViewController(withIdentifier: controllerID!)
        
        origin.show(mainVC, sender: origin)
        
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
