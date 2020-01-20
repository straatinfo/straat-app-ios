//
//  TeamChatListMemberVC.swift
//  Straat
//
//  Created by Global Array on 17/01/2020.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class TeamChatListMemberVC: UIViewController {

	@IBOutlet weak var teamChatListMemberTV: UITableView!
	
	var teamId: String?
	var conversations = [Conversation]()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		loadingShow(vc: self)
		self.getTeamMember { (success, conversations) in
			if success {
				self.conversations = conversations!
			}
			self.teamChatListMemberTV.reloadData()
			loadingDismiss()
		}
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	func getTeamMember(completion: @escaping (Bool, [Conversation]?) -> Void) -> Void {
		let uds = UserDefaults.standard
		let teamService = TeamService()
		
		let userId = uds.string(forKey: user_id) ?? ""
		let teamId = uds.string(forKey: chat_vc_team_id) ?? ""
		let teamName = uds.string(forKey: chat_vc_team_name) ?? ""
		let teamConvoId = uds.string(forKey: chat_vc_conversation_id) ?? ""
		let msgCount = uds.string(forKey: chat_vc_msg_count) ?? ""
		let profilePicUrl = uds.string(forKey: chat_vc_profile_url) ?? ""

		teamService.getTeamChatMemberList(teamId: teamId, userId: userId) { (success, message, conversations, teamMessagePrev) in
			if success {
				var convos = [Conversation]()
				let teamConvoObject: [String:Any] = [
					"type": "TEAM",
					"_id": teamConvoId,
					"chatName": teamName,
					"unreadMessageCount": msgCount,
					"profilePicUrl": profilePicUrl,
					"messagePreview": teamMessagePrev!
				]
				
				let teamConvo = Conversation(conversation: JSON(teamConvoObject))
				convos.append(teamConvo)
				for convo in conversations! {
					convos.append(convo)
				}
				debugPrint("conversations: \(String(describing: convos))")
				
				completion(true, convos)
			} else {
				completion(false, nil)
			}
		}
		
	}

}

extension TeamChatListMemberVC {
	func getTeamId(teamId: String) -> Void {
		self.teamId = teamId
	}
}

extension TeamChatListMemberVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.conversations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamChatListMemberTVC
		let convoIndex = self.conversations[indexPath.row]
		let lastConvo = "\(convoIndex.messagePreview!["author"].stringValue) \(convoIndex.messagePreview!["body"].stringValue)"
		
		row.memberName.text = convoIndex.chatName
		row.lastConvo.text = lastConvo
		row.date.text = convoIndex.messagePreview!["createdAt"].stringValue
		
		if convoIndex.profilePicUrl != nil && convoIndex.profilePicUrl != "" {
			
			self.getTeamImage(imageUrl: (convoIndex.profilePicUrl)!) { (success, image) in
				if success {
					row.memberImage.image = image
				}
			}
		}
		
		return row
	}
	
}

extension TeamChatListMemberVC {
	func getTeamImage(imageUrl: String, completion: @escaping (Bool, UIImage?) -> Void) -> Void {
		
		Alamofire.request(URL(string: imageUrl)!).responseImage { response in
			
			if let img = response.result.value {
				print("team image downloaded: \(img)")
				completion(true, img)
			} else {
				completion(false, nil)
			}
		}
	}
}
