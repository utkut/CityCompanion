//
//  FerryTableView.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 6/5/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//

import Foundation
import UIKit

class FerryTableView : UITableViewController {
    var incomingFerryStation = ""
    
    // Data Section
    
    let BostanliAlsancak = ["07:20","07:35","07:50","08:05","08:20","08:35","08:50","09:05","09:20","09:35","09:50","10:05","10:50","11:35","12:20","13:05","13:50","14:35","15:20","16:05","17:05","17:20","17:35","17:50","18:05","18:20","18:35","18:50","19:05","19:50","20:35","21:20","22:05","22:50"]
    
    let BostanliUckuyular = ["07:10","07:50","08:25","09:00","09:35","10:10","10:50","11:30","12:10","12:50","13:30","14:10","14:50","15:30","16:05","16:40","17:15","17:50","18:25","19:00","19:40","20:20","21:00","21:40","22:20","23:00"]
    
    let BostanliPasaport = ["07:20","07:35","07:50","08:05","08:20","08:35","08:50","09:05","09:20","09:35","09:50","10:05","10:50","11:35","12:20","13:05","13:50","14:35","15:20","16:05","17:05","17:20","17:35","17:50","18:05","18:20","18:35","18:50","19:05","19:50","20:35","21:20","22:05","22:50"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BostanliAlsancak.count
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        // This part doesnt work yet.
        if incomingFerryStation == "Alsancak" {
             cell.textLabel?.text = BostanliAlsancak[indexPath.row]
             
        }
        
        if incomingFerryStation == "Pasaport" {
            cell.textLabel?.text = BostanliPasaport[indexPath.row]
        }
       
        return cell
    }
}
