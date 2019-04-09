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
    let manager = SocketManager(socketURL: URL(string: "https://straatinfo-backend-v2-prod.herokuapp.com")!, config: [.log(true), .compress])
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
    
    func onSendMessageSuccess(callback: @escaping (Bool) -> Void) { // --> add callback function
        socket.on("send-message-v2") { (data, ack) in
            
            print("received a message", data)
            
            callback(true)
        }
    }
    
    func getNewMessage(callback: @escaping (Bool) -> Void) { // --> @TODO optimize later
        socket.on("new-message") { (data, ack) in
            print("New message received")
            
            callback(true)
        }
    }
    
    func onRegistration () { // --> add callback function
        socket.on("register") { (date, ack) in
            print("Registration success")
        }
    }
    
    func sendMessage (conversationId: String,  userId: String, text: String) {
        var data: [String: Any] = [:]
        data["user"] = userId
        data["_conversation"] = conversationId
        data["text"] = text
        data["_id"] = userId // should be source id
        socket.emit("send-message-v2", data)
    }
}
