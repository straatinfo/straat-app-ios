//
//  SendCommunicationReviewVC.swift
//  Straat
//
//  Created by Global Array on 20/12/2019.
//

import UIKit
import iOSDropDown
import SwiftyJSON

class SendCommunicationReviewVC: UIViewController {

	@IBOutlet weak var cagetory: UITextField!
	@IBOutlet weak var message: UITextField!
	@IBOutlet weak var teamList: UITextField!
	
	var imageMetaData1: Dictionary <String, Any>?
	var imageMetaData2: Dictionary <String, Any>?
	var imageMetaData3: Dictionary <String, Any>?
	
	var categoryName: String?
	var categoryId: String?
	var isUrgent: Bool?
	var isInMap: Bool?
	var msg: String?
	var activeTeam: String?
	
	var selectedTeamIds = [String]()
	
	let reportService = ReportService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getInputs()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func sendReport(_ sender: UIButton) {

		sendReportTypeC()
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
			for team in teamModels {
				teamNames.append(team.teamName!)
				self.selectedTeamIds.append(team.teamId!)
			}
			self.teamList.loadDropdownData(data: teamNames)
		}

	}
	

	func getInputs() -> Void {
	
		
		let uds = UserDefaults.standard
		self.categoryName = uds.string(forKey: report_c_category)
		self.categoryId = uds.string(forKey: report_c_category_id)
		self.isUrgent = uds.bool(forKey: report_c_is_notif)
		self.isInMap = uds.bool(forKey: report_c_show_map)
		self.msg = uds.string(forKey: report_c_message)
		
		self.imageMetaData1 = uds.value(forKey: report_c_img1) as? Dictionary<String,Any>
		self.imageMetaData2 = uds.value(forKey: report_c_img2) as? Dictionary<String,Any>
		self.imageMetaData3 = uds.value(forKey: report_c_img3) as? Dictionary<String,Any>
			
		self.cagetory.text = self.categoryName
		self.message.text = self.msg

		debugPrint("show in map \(String(describing: self.isInMap))")
//		debugPrint("cat \(String(describing: categoryName))")
//		debugPrint("notif \(String(describing: isUrgent))")
//		debugPrint("showmap \(String(describing: isShowToMap))")
//		debugPrint("message \(String(describing: message))")
//
//		debugPrint("imgdata1 \(String(describing: imageMetaData1))")
//		debugPrint("imgdata2 \(String(describing: imageMetaData2))")
//		debugPrint("imgdata3 \(String(describing: imageMetaData3))")
		
	}
	
	func sendReportTypeC () -> Void {

		loadingShow(vc: self)
		//
		var imageMetaDatas = [[String: Any]]()
		let uds = UserDefaults.standard
		//
		let id = uds.string(forKey: user_id)
		let loc_add = uds.string(forKey: user_loc_address)
		let lat = uds.double(forKey: user_loc_lat)
		let long = uds.double(forKey: user_loc_long)
		let host_id = uds.string(forKey: report_host_id) ?? uds.string(forKey: user_host_id) ?? ""
		let team_id = uds.string(forKey: user_team_id)
		
		//
		if self.imageMetaData1 != nil {
			imageMetaDatas.append(self.imageMetaData1!)
		}
		
		if self.imageMetaData2 != nil {
			imageMetaDatas.append(self.imageMetaData2!)
		}
		
		if self.imageMetaData3 != nil {
			imageMetaDatas.append(self.imageMetaData3!)
		}
		
//		let js = JSON(self.selectedTeamIds)
		
//		debugPrint("ids: \(js.arrayValue)")
//		debugPrint("id \(String(describing: id))")
//		debugPrint("loc \(String(describing: loc_add))")
//		debugPrint("lat \(lat)")
//		debugPrint("long \(long)")
//		debugPrint("host \(host_id)")
//		debugPrint("teamIds \(selectedTeamIds)")
//		debugPrint("active_team \(team_id)")
//		debugPrint("category_name \(self.categoryName)")
		
//		let sendReportModel = SendReportModel(
//			title: "Suspicious Situation",
//			description: self.msg,
//			location: loc_add,
//			long: long,
//			lat: lat,
//			reporterId: id,
//			hostId: host_id,
//			mainCategoryId: self.categoryId,
//			isUrgent: self.isUrgent,
//			isInMap: self.isInMap,
//			teamList: self.selectedTeamIds,
//			reportUploadedPhotos: imageMetaDatas,
//			reportTypeId: report_type_c_id)
		
		let sendReportModel = SendReportModel(
			title: "Suspicious Situation",
			description: self.msg,
			location: loc_add,
			long: long,
			lat: lat,
			reporterId: id,
			hostId: host_id,
			mainCategoryId: self.categoryId,
			isUrgent: self.isUrgent,
			isInMap: self.isInMap,
			teamList: self.selectedTeamIds,
			reportUploadedPhotos: imageMetaDatas,
			reportTypeId: report_type_c_id,
			mainCategoryName: self.categoryName,
			teamId: team_id)

			self.reportService.sendReportTypeC(reportDetails: sendReportModel) { (success, message) in
				if success {
					let alertController = UIAlertController(title: "Dank voor uw melding!", message: message, preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in

						pushToNextVC(sbName: "Main", controllerID: "SWRevealViewControllerID", origin: self)
					}))

					self.present(alertController, animated: true)
					debugPrint("Success")
				} else {
					defaultDialog(vc: self, title: "Send Report Error", message: message)
				}
				loadingDismiss()
			}
		
	}
}
