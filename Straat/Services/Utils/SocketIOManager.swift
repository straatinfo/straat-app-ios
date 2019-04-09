//
//  SocketIOManager.swift
//  Straat
//
//  Created by John Higgins M. Avila on 09/04/2019.
//

import UIKit
import SocketIO

//let uds = UserDefaults.standard
//
//let userId = uds.string(forKey: user_id) ?? ""
//
//class SocketConnection {
//    // MARK: - Properties
//
//    static let manager = SocketManager(socketURL: URL(string: "https://straatinfo-backend-v2-prod.herokuapp.com/?_user\(userId)&token=token")!, config: [.log(true)])
//
//    // MARK: -
//
//    static var socket: SocketIOClient! = manager.defaultSocket
//
//    let baseURL: URL
//
//    // Initialization
//
//    private init(baseURL: URL) {
//        self.baseURL = baseURL
//    }
//}


class SocketIOManager: NSObject {
    let manager = SocketManager(socketURL: URL(string: "https://straatinfo-backend-v2.herokuapp.com")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    static let shared = SocketIOManager()
    
    override init() {
        super.init()
        
        socket = manager.defaultSocket
    }
    
    
    func connectSocket() {
        print("trying to connect")
        let uds = UserDefaults.standard
        let userId = uds.string(forKey: user_id) ?? ""
        
        self.manager.config = SocketIOClientConfiguration(
            arrayLiteral: .connectParams(["token": "token", "_user": userId]), .secure(true) // problem is here in passing token value
        )
        socket.connect()
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
    }
    
    // 1) Add callbacks -> ReportService
    // 2) Add emit per function
    // 3) Call sendMessage at MainVC.swift
    
    
    func onSendMessageSuccess() { // --> add callback function
        socket.on("send-message-v2") { (data, ack) in
            print("received a message", data) // -> completion
            
        }
    }
    
    // Compare conversation ID from payload
    func getNewMessage(completion: @escaping (ChatModel) -> Void) { // --> add callback function
        socket.on("new-message") { (data, ack) in
            print("New message received")
            
            var chatModel = [ChatModel]()
            let id = category["_id"] as? String
            
            completion(data)
        }
    }
    
    func onRegistration () { // --> add callback function
        socket.on("register") { (date, ack) in
            print("Registration success")
        }
    }
}
