//
//  VapurViewController.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 6/5/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//

import Foundation
import UIKit

class FerryViewController: ViewController {

    @IBOutlet weak var FerryName: UILabel!
    @IBOutlet weak var destinationPicker: UIPickerView!
    var IzmirFerryData = ["Bostanli", "Karsiyaka", "Alsancak", "Pasaport", "Konak", "Goztepe", "Uckuyular"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension FerryViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return IzmirFerryData.count
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
    // Return a string from the array for this row.
    return IzmirFerryData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
