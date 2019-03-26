//
//  TeamChatVC.swift
//  Straat
//
//  Created by Global Array on 23/03/2019.
//

import UIKit

class TeamChatVC: UIViewController {

	@IBOutlet weak var chatTableView: UITableView!
	@IBOutlet weak var messageContent: UITextField!
	@IBOutlet weak var sendMessageButton: UIButton!

	let chatService = ChatService()
	var userId: String?
	var conversationId: String?
	var chatModel = [ChatModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.disableSendMessageButton()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.initView()
	}
	
	@IBAction func sendMessage(_ sender: UIButton) {
		self.chatService.sendMessage(authorId: self.userId!, message: self.messageContent.text!, conversationId: self.conversationId!) { (success, message) in
			if success {
				let alertController = UIAlertController(title: "Send Message", message: message, preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
					self.navigationController?.popViewController(animated: true)
				}))
				self.present(alertController, animated: true, completion: nil)
			} else {
				let alertController = UIAlertController(title: "Send Message", message: message, preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
					self.navigationController?.popViewController(animated: true)
				}))
				self.present(alertController, animated: true, completion: nil)
			}
		}
	}
	
}

extension TeamChatVC : UITextFieldDelegate {
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
		switch textField {
		case messageContent:
			if textField.text?.isValidDescription() ?? false {
				checkTextFieldValues()
			} else {
				messageContent.becomeFirstResponder()
				validationDialog(vc: self, title: "Message content invalid", message: "Please check your message if empty or does have special character", buttonText: "Ok")
				disableSendMessageButton()
			}
		default:
			break
		}
	}
	
	
	func initView() -> Void {
		
		let uds = UserDefaults.standard
		let userId = uds.string(forKey: user_id) ?? ""
		let teamMemberId = uds.string(forKey: team_member_id) ?? ""
		self.userId = userId

		loadingShow(vc: self)
		self.chatService.createConverstation(authorId: userId, chatee: teamMemberId) { (success, message, conversationId) in
			if success {
				self.conversationId = conversationId
				debugPrint("userId: \(userId)")
				debugPrint("convoId: \(conversationId)")
				
				self.chatService.getReportConversation(userId: self.userId!, conversationId: self.conversationId!)
				{ (success, message, chatModel) in
					if success {
						self.chatModel = chatModel ?? []
						                debugPrint("chatModel: \(self.chatModel[0].author?.userName)")
					}
					loadingDismiss()
					self.chatTableView.reloadData()
				}
				
			} else {
				loadingDismiss()
				defaultDialog(vc: self, title: "Creating Conversation", message: "Problem in Creating conversation")
			}
		}
		

	}
	
	func sendMessage() -> Void {
		
	}
	
	func disableSendMessageButton() {
		self.sendMessageButton.isEnabled = false
		self.sendMessageButton.backgroundColor = UIColor.lightGray
	}
	
	func enableSendMessageButton() {
		self.sendMessageButton.isEnabled = true
		self.sendMessageButton.backgroundColor = UIColor.init(red: 122/255, green: 174/255, blue: 64/255, alpha: 1)
		debugPrint("enable next step")
	}
	
	func checkTextFieldValues() {
		
		if self.textFieldHasValues(tf: [self.messageContent]) {
			enableSendMessageButton()
		} else {
			disableSendMessageButton()
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

extension TeamChatVC : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.chatModel.count
	}
	
	//	research later for multiple tvc in one tableview
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let chatModel = self.chatModel[indexPath.row]
		
		var row : TeamChatTVC?
		
		if chatModel.author?.id == self.userId {
			row = tableView.dequeueReusableCell(withIdentifier: "row2", for: indexPath) as? TeamChatTVC
			row?.yourMessage.text = chatModel.body ?? ""
			row?.yourTime.text = chatModel.createdAt ?? ""
			debugPrint("your message")
			//			debugPrint("userid: \(chatModel.author?.id)")
			//			debugPrint("usernmae: \(chatModel.author?.userName)")
			//			debugPrint("message: \(chatModel.body)")
			//			debugPrint("convoid: \(chatModel.convoId)")
			//			debugPrint("time: \(chatModel.createdAt)")
			
		}
		else {
			row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as? TeamChatTVC
			row?.otherUsername.text = chatModel.author?.userName ?? ""
			row?.otherMessage.text = chatModel.body ?? ""
			row?.otherTime.text = chatModel.createdAt ?? ""
			debugPrint("row2")
			
		}
		
		
		return row ?? UITableViewCell()
	}
	
	
}

