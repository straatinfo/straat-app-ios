//
//  Loading.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation
import UIKit


var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()


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

func loadingDismiss() {
    
    activityIndicator.stopAnimating()
//    alertController.dismiss(animated: true, completion: nil)
    
}

func defaultDialog( vc: UIViewController, title : String? , message : String?) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    vc.present(alertController, animated: true)
    
}
