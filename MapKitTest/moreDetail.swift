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
    
    
    var incomingStationName: String?
    var incomingStationType: String?
    
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
    
    if (dayInWeek == "Saturday" || dayInWeek == "Monday"){
        etaLabel.text = "No Lines Running Today."
    }
    else{
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH.mm"
        let dayinHours = dateFormatter.string(from: date)
        
        if let myTime = Double(dayinHours){
            
            if (myTime >= 06.00 && myTime < 10.00){
                etaLabel.text = "Tram is every 7.5 minutes. "
            }
            if (myTime >= 10.00 && myTime < 16.00){
                etaLabel.text = "Tram is every 40 minutes. "
            }
            if (myTime >= 16.00 && myTime < 21.00){
                etaLabel.text = "Tram is every 10 minutes. "
            }
            if (myTime >= 21.00 && myTime < 23.59){
                etaLabel.text = "Tram is every 40 minutes. "
            }
            else{
                 etaLabel.text = "Tram is Not Running at the Moment. "
            }
        }
        else{
            etaLabel.text = "Unable to Retrieve. "
            
        }
    }
}
    
}

