//
//  SuspiciousSituationVC.swift
//  Straat
//
//  Created by Global Array on 15/02/2019.
//

import UIKit

class SuspiciousSituationVC: UIViewController {

    let sampleArr = ["arr1", "arr2", "arr3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension SuspiciousSituationVC : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! PublicSpaceTVC
        
        row.reportCategory.text = "category: \(sampleArr[indexPath.row])"
        row.id = sampleArr[indexPath.row]
        
        return row
        
    }
    
    
    
}
