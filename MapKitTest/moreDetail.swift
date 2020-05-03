//
//  moreDetail.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 4/26/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//

import Foundation
import UIKit


class moreDetail : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var stationType: UILabel!
    
    
    var incomingStationName: String? = nil
    var incomingStationType: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationName.text = incomingStationName
        stationType.text = incomingStationType
        getTramFrequency()
    
    }
    

// Function to read the frequency of Tram depending on the day.
func getTramFrequency() {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let dayInWeek = dateFormatter.string(from: date)
}
    
}

