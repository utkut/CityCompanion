//
//  infoViewController.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 4/28/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
//

import Foundation
import UIKit
import SafariServices

class infoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Code to be executed at startup
        label1.sizeToFit()
        label2.sizeToFit()
        
    }

    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBAction func visitWebsiteClicked(_ sender: Any) {
        if let url = URL(string: "https://utkutarhan.com"){
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    
}
