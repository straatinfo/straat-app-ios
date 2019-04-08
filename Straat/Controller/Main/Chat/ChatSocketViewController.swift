//
//  ChatSocketViewController.swift
//  Straat
//
//  Created by Jamie on 08/04/2019.
//

import UIKit
import SocketIO

struct NewsAPIStruct:Decodable {
    // To change
    let headlines:[Headlines];
}

struct Headlines:Decodable {
    // To change
    let newsgroupID:Int;
    let newsgroup: String;
    let headline: String;
    
    init (json: [String: Any]) {
        // To change
        newsgroupID = json ["newsgroupID"] as? Int ?? -1;
        newsgroup = json ["newsgroup"] as? String ?? "";
        headline = json ["headline"] as? String ?? "";
    };
};

class ChatSocketViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var tableView:UITableView!;
    private var headlinesArray = [String]();
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headlinesArray.count;
    };
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print ( self.headlinesArray[indexPath.row])
        cell.textLabel?.text = self.headlinesArray[indexPath.row];
        return cell
    };
    
    // To change
    let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!,config: [.log(true),.connectParams(["token": "token"])])
    
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTable();
        self.socket = manager.defaultSocket;
        self.setSocketEvents();
        
        self.socket.connect();
        self.getHeadlines();
    }
    
    private func setTable() {
        let displayWidth: CGFloat = self.view.frame.width;
        let displayHeight: CGFloat = self.view.frame.height;
        
        self.tableView = UITableView(frame: CGRect(x: 0, y:0, width: displayWidth, height: displayHeight));
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.view.addSubview(self.tableView);
    };
    
    func getHeadlines() {
        self.headlinesArray = [];
        
        // To change
        let jsonURLString:String = "http://localhost:3000/headlines/?token=token";
        guard let url = URL(string: jsonURLString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                let newsAPIStruct = try
                    JSONDecoder().decode(NewsAPIStruct.self, from: data)
                
                for item in newsAPIStruct.headlines {
                    self.headlinesArray.append (item.headline);
                };
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            } catch let jsonErr {
                print ("error: ", jsonErr)
            }
            }.resume();
    };
    
    private func setSocketEvents() {
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected");
        };
        
        self.socket.on("headlines_updated") {data, ack in
            self.getHeadlines();
        };
    };

}
