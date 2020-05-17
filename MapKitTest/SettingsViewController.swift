//
//  SettingsViewController.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 5/13/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
//
import Foundation
import UIKit

var citiesData = ["Izmir", "San Francisco", "Istanbul", "Ankara", "Cupertino", "Antalya" ]
var selectedData:Int = 0


class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var cityPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityPicker.dataSource = self
        self.cityPicker.delegate = self
           }
    
    
    
   @IBAction func setCityButtonClicked(_ sender: Any) {
//    self.delegate?.SendDataToViewController(info: )
   let num = cityPicker.selectedRow(inComponent: 0) + 1
   let all = self.navigationController!.viewControllers
   let vcB = all[all.count - 2] as! ViewController
   vcB.determineCity(input: num)
    self.navigationController?.popToRootViewController(animated: true)
    }

    
}
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return citiesData.count
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
    // Return a string from the array for this row.
    return citiesData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
