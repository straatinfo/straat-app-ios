//
//  MsgMainTabBarController.swift
//  Straat
//
//  Created by Global Array on 03/02/2019.
//

import UIKit

class CustomTabBarController: UITabBarController {
    let chatService = ChatService()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading ctb")
        // Do any additional setup after loading the view.
        self.socketSetup()
        self.updateBadgeValue()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic-map")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic-map")
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
//    override func viewWillLayoutSubviews() {
//
//        self.updateBadgeValue()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        self.updateBadgeValue()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateBadgeValue()
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

extension CustomTabBarController {
    func socketSetup () {
        SocketIOManager.shared.getNewMessage(callback: { (success) in
           self.updateBadgeValue()
//            if self.badgeUpdateDelegate != nil {
//                self.badgeUpdateDelegate.didBadgeShouldUpdate()
//            }
        })
    }
}

extension CustomTabBarController {
    func updateBadgeValue () {
        let user = UserModel()
        
        self.chatService.getUnreadMessageCount(userId: user.id!) { (success, response) in
            let items = self.tabBar.items
            if success && response != nil {
                
                let a = response!["a"].int
                let b = response!["b"].int
                let c = response!["c"].int
                let team = response!["team"].int
                
                if a != nil && a! > 0 {
                    items?[0].badgeValue = String(a!)
                } else {
                    items?[0].badgeValue = nil
                }
                if b != nil && b! > 0 {
                    items?[1].badgeValue = String(b!)
                } else {
                    items?[1].badgeValue = nil
                }
                if c != nil && c! > 0 {
                    items?[2].badgeValue = String(c!)
                } else {
                    items?[2].badgeValue = nil
                }
                if team != nil && team! > 0 {
                    items?[3].badgeValue = String(team!)
                } else {
                    items?[3].badgeValue = nil
                }
            }
        }
    }
}
