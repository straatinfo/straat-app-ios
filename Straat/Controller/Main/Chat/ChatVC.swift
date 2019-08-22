//
//  ChatViewController.swift
//  Straat
//
//  Created by Global Array on 21/03/2019.
//

import UIKit
import SwiftyJSON

class ChatVC: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
	@IBOutlet weak var messageContent: UITextField!
	@IBOutlet weak var sendMessageButton: UIButton!

	let chatService = ChatService()
	var userId: String?
	var conversationId: String?
	var chatModel = [ChatModel]()
    let uds = UserDefaults.standard
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.disableSendMessageButton()
        self.readMessages()
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationItem.backBarButtonItem?.title = ""
        
        SocketIOManager.shared.getNewMessage() { (success) in
            print("Receiving new message")
            self.initView()
        }
		
//		let queue = DispatchQueue(label: "convo", qos: .userInteractive)
//		queue.async {
//			self.initView()
//			debugPrint("convo thread")
//		}
		
//		DispatchQueue.global(qos: .userInitiated).async {
//			DispatchQueue.main.async {
//				self.initView()
//				debugPrint("convo thread")
//			}
//		}

    }
    
    

	override func viewWillAppear(_ animated: Bool) {
        self.initView()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationItem.backBarButtonItem?.title = ""
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        self.readMessages()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic-map")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic-map")
        self.navigationItem.backBarButtonItem?.title = ""
    }
	
	@IBAction func sendMessage(_ sender: UIButton) {
//        self.chatService.sendMessage(authorId: self.userId!, message: self.messageContent.text!, conversationId: self.conversationId!) { (success, message) in
//            if success {
//                let alertController = UIAlertController(title: "Send Message", message: message, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action:UIAlertAction) in
//                        self.navigationController?.popViewController(animated: true)
//                            self.removeConvoLocalData()
//                    }))
//                self.present(alertController, animated: true, completion: nil)
//            } else {
//                let alertController = UIAlertController(title: "Send Message", message: message, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action:UIAlertAction) in
//                        self.navigationController?.popViewController(animated: true)
//                            self.removeConvoLocalData()
//                }))
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
        
        let authorId = self.userId ?? ""
        let message = self.messageContent.text ?? ""
    
        let userId = uds.string(forKey: user_id) ?? ""
        let reporterId = uds.string(forKey: reporter_id) ?? ""
        let conversationId = uds.string(forKey: chat_vc_conversation_id) ?? ""
        let chatTitle = uds.string(forKey: chat_vc_title) ?? "CHAT"
        let chatType = uds.string(forKey: chat_vc_type) ?? ""
        let teamId = uds.string(forKey: chat_vc_team_id)
        let reportId = uds.string(forKey: chat_vc_report_id)
        
        self.navigationItem.title = chatTitle
        
        switch chatType {
        case "REPORT":
            print("CHAT_TYPE: REPORT, conversationID: \(conversationId)")
            var json = JSON()
            json["_report"].string = reportId
            json["text"].string = message
            json["_conversation"].string = conversationId
            
            json["_id"].string = userId
            json["user"].string = userId
            json["type"].string = "REPORT"
            SocketIOManager.shared.sendMessage(payload: json)
        case "TEAM":
            print("CHAT_TYPE: REPORT, conversationID: \(conversationId)")
            var json = JSON()
            json["_team"].string = teamId
            json["text"].string = message
            json["_conversation"].string = conversationId
            json["_id"].string = userId
            json["user"].string = userId
            json["type"].string = "TEAM"
            SocketIOManager.shared.sendMessage(payload: json)
        default:
            SocketIOManager.shared.sendMessage(conversationId: conversationId, userId: authorId, text: message)
        }
        
	}
	
}

extension ChatVC : UITextFieldDelegate {

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // textField.resignFirstResponder()
        switch textField {
        case messageContent:
            if textField.text?.isValidDescription() ?? false {
                checkTextFieldValues()
            } else {
                // messageContent.becomeFirstResponder()
                //                validationDialog(vc: self, title: "Message content invalid", message: "Please check your message if empty or does have special character", buttonText: "Ok")
                disableSendMessageButton()
            }
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(ChatVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		// textField.resignFirstResponder()
		switch textField {
		case messageContent:
			if textField.text?.isValidDescription() ?? false {
				checkTextFieldValues()
			} else {
				// messageContent.becomeFirstResponder()
//                validationDialog(vc: self, title: "Message content invalid", message: "Please check your message if empty or does have special character", buttonText: "Ok")
				disableSendMessageButton()
			}
		default:
		break
		}
	}

   
	
	
    func initView() -> Void {
		print("LOADING INIT VIEW")
        let uds = UserDefaults.standard
        let userId = uds.string(forKey: chat_vc_user_id) ?? ""
        let reporterId = uds.string(forKey: chat_vc_user_id) ?? ""
        let conversationId = uds.string(forKey: chat_vc_conversation_id) ?? ""
        let chatTitle = uds.string(forKey: chat_vc_title) ?? "CHAT"
        let chatType = uds.string(forKey: chat_vc_type) ?? ""
        let teamId = uds.string(forKey: chat_vc_team_id)
		let reportId = uds.string(forKey: chat_vc_report_id)
		self.userId = userId
		self.conversationId = uds.string(forKey: chat_vc_conversation_id)
        
        self.navigationItem.title = chatTitle
		
        debugPrint("reporterId: \(reporterId)")
        debugPrint("convoId: \(conversationId)")
        
        loadingShow(vc: self)
        chatService.getReportConversation(userId: reporterId, conversationId: conversationId)
		{ (success, message, chatModel) in
            if success {
					self.chatModel = chatModel ?? []
//                debugPrint("chatModel: \(self.chatModel[0].author?.userName)")
            }
            loadingDismiss()
			self.chatTableView.reloadData()
            if self.chatModel.count > 1 {
                let lastIndex = IndexPath(row: self.chatModel.count - 1, section: 0)
                print("LAST_INDEX: \(lastIndex)")
                self.chatTableView.scrollToRow(at: lastIndex, at: UITableView.ScrollPosition.bottom, animated: false)
            }
            
        }
        
        SocketIOManager.shared.onSendMessageSuccess() { success in
//            let alertController = UIAlertController(title: "Send Message", message: "Success", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action:UIAlertAction) in
//                // self.navigationController?.popViewController(animated: true)
//                self.removeConvoLocalData()
//                self.messageContent.text = ""
//            }))
//            self.present(alertController, animated: true, completion: nil)
            self.removeConvoLocalData()
            self.messageContent.text = ""
            self.disableSendMessageButton()
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
	
	func removeConvoLocalData() -> Void {
		let uds = UserDefaults.standard
		uds.removeObject(forKey: reporter_id)
		uds.removeObject(forKey: report_conversation_id)

	}
	
}

extension ChatVC : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.chatModel.count
	}

//	research later for multiple tvc in one tableview
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let chatModel = self.chatModel[indexPath.row]
		
		var row : ChatTVC?
		
		if chatModel.author?.id == self.userId {
			row = tableView.dequeueReusableCell(withIdentifier: "row2", for: indexPath) as? ChatTVC
			row?.yourMessage.text = chatModel.body ?? ""
            row?.yourTime.text = chatModel.createdAt?.toDate(format: "d MMM yyyy HH:MM") ?? ""
//			debugPrint("userid: \(chatModel.author?.id)")
//			debugPrint("usernmae: \(chatModel.author?.userName)")
//			debugPrint("message: \(chatModel.body)")
//			debugPrint("convoid: \(chatModel.convoId)")
//			debugPrint("time: \(chatModel.createdAt)")

		}
		else {
			row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as? ChatTVC
			row?.otherUsername.text = chatModel.author?.userName ?? ""
			row?.otherMessage.text = chatModel.body ?? ""
            row?.otherTime.text = chatModel.createdAt?.toDate(format: "d MMM yyyy HH:MM") ?? ""
			debugPrint("row2")

		}
		

		return row ?? UITableViewCell()
	}
	
	
}


extension ChatVC {
    func readMessages () {
        let conversationId = uds.string(forKey: chat_vc_conversation_id) ?? ""
        let userId = uds.string(forKey: user_id) ?? ""
        
        self.chatService.readUnreadMessages(conversationId: conversationId, userId: userId) { (success, message) in
            
        }
    }
}
