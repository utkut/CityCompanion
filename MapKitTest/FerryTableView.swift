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
    let BostanliAlsancak = ["07:20","07:35","07:50","08:05","08:20","08:35","08:50","09:05","09:20","09:35","09:50","10:05","10:50","11:35","12:20","13:05","13:50","14:35","15:20","16:05","17:05","17:20","17:35","17:50","18:05","18:20","18:35","18:50","19:05","19:50","20:35","21:20","22:05","22:50"]
    let BostanliUckuyular = [""]
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
        cell.textLabel?.text = BostanliAlsancak[indexPath.row]
        return cell
    }
}
