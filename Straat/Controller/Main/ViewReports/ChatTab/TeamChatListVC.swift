//
//  TeamChatListVC.swift
//  Straat
//
//  Created by Global Array on 25/03/2019.
//

import UIKit
import Alamofire
import AlamofireImage

class TeamChatListVC: UIViewController {

	let chatService = ChatService()
	var userId: String?
	var chatModel = [ChatModel]()
	
	@IBOutlet weak var teamChatListTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.initView()
	}

}

extension TeamChatListVC {
	func initView() -> Void {
		
		let uds = UserDefaults.standard
		let userId = uds.string(forKey: user_id) ?? ""

		self.userId = userId
		
		debugPrint("userId: \(userId)")
		
		loadingShow(vc: self)
			self.chatModel.removeAll()
		self.chatService.getTeamMemberConversation(userId: userId) { (success, message, chatModels) in

			if success {
				for chatModelItem in chatModels! {
//					if chatModelItem.author?.id != userId {
						self.chatModel.append(chatModelItem)						
						debugPrint("chatmodeitem: \(chatModelItem.imageUrl)")
//					}
				}
				loadingDismiss()
				self.teamChatListTableView.reloadData()
			}
			
		}
	}
	
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


extension TeamChatListVC : UITextViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.chatModel.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamChatListTVC
		let teamMember = self.chatModel[indexPath.row]
		
		row.reporterId = teamMember.author?.id
		row.convoId = teamMember.convoId
		row.teamName.text = teamMember.author?.userName
		row.teamLatestMessage.text = teamMember.body

		debugPrint("team image url: \(teamMember.imageUrl)")
		if teamMember.imageUrl != "" {

			self.getTeamImage(imageUrl: (teamMember.imageUrl)!) { (success, image) in
				if success {
					row.teamLogo.image = image
				}
			}
		}
		
		return row
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let teamMember = self.chatModel[indexPath.row]
		let convoId = teamMember.convoId
		
	}

	

	
}
