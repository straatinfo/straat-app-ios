//
//  PrototypeViewController.swift
//  Straat
//
//  Created by Global Array on 29/03/2019.
//

import UIKit
import GoogleMaps

class PrototypeViewController: UIViewController {

	@IBOutlet weak var googleMapContainer: UIView!
	var googleMapView: GMSMapView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		
		self.googleMapView = GMSMapView(frame: self.googleMapContainer.frame)
		self.view.addSubview(self.googleMapView)		
		
	}


}

extension PrototypeViewController {
	
}
