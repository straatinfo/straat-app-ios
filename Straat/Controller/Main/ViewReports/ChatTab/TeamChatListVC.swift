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
    var teamList = [TeamModel]()
    let teamService = TeamService()
	
	@IBOutlet weak var teamChatListTableView: UITableView!
    
    let fcmNotificationName = Notification.Name(rawValue: fcm_new_message)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // self.onNewMessageReceived()
        self.teamList.removeAll()
        self.loadChatRooms()
        self.createObservers()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
        self.teamList.removeAll()
        self.loadChatRooms()
	}
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

}

extension TeamChatListVC {
	func initView() -> Void {
		
		let uds = UserDefaults.standard
		let userId = uds.string(forKey: user_id) ?? ""

		self.userId = userId
		
		debugPrint("userId: \(userId)")
    
        self.teamList.removeAll()
        self.loadChatRooms()
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
		return self.teamList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         var reporterId: String?
         var convoId: String?
         var conversationId: String?
         var type = "REPORT"
         var teamId: String?
         var chatTitle: String?
         var userId: String?
         */
        
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! TeamChatListTVC
        if self.teamList.count > 0 && self.teamList.count - 1 >= indexPath.row {
            let user = UserModel()
            let team = self.teamList[indexPath.row]
            
            row.teamName.text = team.teamName
            row.teamId = team.teamId
            row.userId = user.id
            row.chatTitle = "\(team.teamName ?? "TEAM") - Team chat"
            row.type = "TEAM"
            row.convoId = team.conversationId
            row.conversationId = team.conversationId
            row.reporterId = user.id
            
            
            debugPrint("team image url: \(team.profilePic)")
            if team.profilePic != nil && team.profilePic != "" {
                
                self.getTeamImage(imageUrl: (team.profilePic)!) { (success, image) in
                    if success {
                        row.teamLogo.image = image
                        row.messageCounter.text = "\(team.unreadConversationCount ?? 0)"
                    }
                }
            }
        }
		
		return row
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let team = self.teamList[indexPath.row]
		let convoId = team.conversationId
		
	}

}

// chat setup
extension TeamChatListVC {
    func updateBadgeValue () {
        let user = UserModel()
        
        self.chatService.getUnreadMessageCount(userId: user.id!) { (success, response) in
            if success && response != nil {
                let unreadMessageCount = response!["team"].int
                if unreadMessageCount != nil && unreadMessageCount! > 0 {
                    self.tabBarItem.badgeValue = String(unreadMessageCount!)
                } else {
                    self.tabBarItem.badgeValue = nil
                }
            }
        }
    }
    
    func loadChatRooms () {
        let user = UserModel()
        let userId = user.id
        teamService.getTeamListByUserId(userId: userId!) { (success, message, teams) in
            self.teamList.removeAll()
            if success && teams != nil {
                for team in teams! {
                    self.teamList.append(team)
                }
                self.teamChatListTableView.reloadData()
            }
        }
    }
}


extension TeamChatListVC {
    func onNewMessageReceived () {
        SocketIOManager.shared.getNewMessage { (success) in
            self.teamList.removeAll()
            self.loadChatRooms()
        }
    }
    
    func createObservers () {
        NotificationCenter.default.addObserver(self, selector: #selector(TeamChatListVC.getNewMessage(notification:)), name: fcmNotificationName, object: nil)
    }
    
    @objc func getNewMessage (notification: NSNotification) {
        let userInfo = notification.userInfo
        self.teamList.removeAll()
        self.loadChatRooms()
    }
}
