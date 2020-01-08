//
//  SendCommunicationReviewVC.swift
//  Straat
//
//  Created by Global Array on 20/12/2019.
//

import UIKit
import iOSDropDown

class SendCommunicationReviewVC: UIViewController {

	@IBOutlet weak var cagetory: UITextField!
	@IBOutlet weak var message: UITextField!
	@IBOutlet weak var teamList: UITextField!
	
	let reportService = ReportService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getInputs()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func sendReport(_ sender: UIButton) {

//		loadingShow(vc: self)
//		
//		var imageMetaDatas = [[String: Any]]()
//		let uds = UserDefaults.standard
//		
//		let id = uds.string(forKey: user_id)
//		let loc_add = uds.string(forKey: user_loc_address)
//		let lat = uds.double(forKey: user_loc_lat)
//		let long = uds.double(forKey: user_loc_long)
//		let host_id = uds.string(forKey: report_host_id) ?? uds.string(forKey: user_host_id) ?? ""
//		let team_id = uds.string(forKey: user_team_id)
//		let reportType_id = "5a7888bb04866e4742f74956"
//		
//		if self.imageMetaData1 != nil {
//			imageMetaDatas.append(self.imageMetaData1!)
//		}
//		
//		if self.imageMetaData2 != nil {
//			imageMetaDatas.append(self.imageMetaData2!)
//		}
//		
//		if self.imageMetaData3 != nil {
//			imageMetaDatas.append(self.imageMetaData3!)
//		}
//		
//		print("image meta datas: \(imageMetaDatas)")
//		
//		let sendReportModel = SendReportModel(
//			title: "Suspicious Situation",
//			description: self.reportDescription.text,
//			location: loc_add,
//			long: long,
//			lat: lat,
//			reporterId: id,
//			hostId: host_id,
//			mainCategoryId: self.mainCategoryId,
//			isUrgent: self.isUrgent,
//			teamId: team_id,
//			reportUploadedPhotos: imageMetaDatas,
//			isVehicleInvolved: self.isVehicleInvolved,
//			vehicleInvolvedCount: self.numberofVehicleInvolved,
//			vehicleInvolvedDescription: self.vehiclesInvolvedDescription.text,
//			isPeopleInvolved: self.isPersonInvolved,
//			peopleInvolvedCount: self.numberofPersonInvolved,
//			peopleInvolvedDescription: self.personsInvolvedDescription.text,
//			reportTypeId: reportType_id)
//		
//		self.reportService.sendReport(reportDetails: sendReportModel) { (success, message) in
//			if success {
//				let alertController = UIAlertController(title: "Dank voor uw melding!", message: message, preferredStyle: .alert)
//				alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
//					
//					pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
//				}))
//				
//				self.present(alertController, animated: true)
//			} else {
//				defaultDialog(vc: self, title: "Send Report Error", message: message)
//			}
//			loadingDismiss()
//		}

		
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

extension SendCommunicationReviewVC {
	func selectedTeams(teamModels: [TeamModel]) {
		var teamNames = [String]()
		DispatchQueue.main.async {
			for teams in teamModels {
				teamNames.append(teams.teamName!)
			}
			
			debugPrint("teamName \(teamNames)")
			self.teamList.loadDropdownData(data: teamNames)
		}

	}
	
	func getInputs() -> Void {
		let uds = UserDefaults.standard
		let categoryName = uds.string(forKey: report_c_category)
		let notif = uds.bool(forKey: report_c_is_notif)
		let showMap = uds.bool(forKey: report_c_show_map)
		let message = uds.string(forKey: report_c_message)
		
		let imgData1 = uds.value(forKey: report_c_img1)
		let imgData2 = uds.value(forKey: report_c_img2)
		let imgData3 = uds.value(forKey: report_c_img3)
		
		self.cagetory.text = categoryName
		self.message.text = message
		
		debugPrint("cat \(String(describing: categoryName))")
		debugPrint("notif \(String(describing: notif))")
		debugPrint("showmap \(String(describing: showMap))")
		debugPrint("message \(String(describing: message))")

		debugPrint("imgdata1 \(String(describing: imgData1))")
		debugPrint("imgdata2 \(String(describing: imgData2))")
		debugPrint("imgdata3 \(String(describing: imgData3))")
		
	}
}