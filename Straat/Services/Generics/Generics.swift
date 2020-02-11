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
        
        loadingLabel.text = NSLocalizedString("please-wait", comment: "")// "Please Wait"
        loadingLabel.textColor = UIColor.white
        loadingLabel.font = loadingLabel.font.withSize(15)
        loadingLabel.textAlignment = .center
        
        activityIndicator!.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator!.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
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
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alertController, animated: true)
        
    }

    func defaultDialog2( vc: UIViewController, title : String? , message : String?, completion: @escaping() -> Void ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alertController, animated: true, completion: completion)
        
    }

    func alertDialogWithPositiveButton (vc: UIViewController, title: String, message: String, positiveBtnName: String, handler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: positiveBtnName, style: .default, handler: handler))
        vc.present(alertController, animated: true)
    }

    func alertDialogWithPositiveAndNegativeButton (vc: UIViewController, title: String, message: String, positiveBtnName: String, negativeBtnName: String, positiveHandler: @escaping(UIAlertAction) -> Void, negativeHandler: @escaping(UIAlertAction) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: positiveBtnName, style: .default, handler: positiveHandler))
        alertController.addAction(UIAlertAction(title: negativeBtnName, style: .cancel, handler: negativeHandler))
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

	extension UIImage {
		enum JPEGQuality: CGFloat {
			case lowest  = 0
			case low     = 0.25
			case medium  = 0.5
		}
		
		func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
			return jpegData(compressionQuality: jpegQuality.rawValue)
		}
	}


extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(9)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        if (number > 9) {
            label.string = "9+"
        } else {
             label.string = "\(number)"
        }
        
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 12
        label.frame = CGRect(origin: CGPoint(x: location.x - 10, y: offset.y + 2), size: CGSize(width: 20, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
