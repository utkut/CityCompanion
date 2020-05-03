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
    
    var incomingtext: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        stationName.text = incomingtext
    
    }
    
    @IBOutlet weak var imageView: UIImageView!
  
    


     
   
        

    
    
    }

    
    


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
