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

var citiesData = ["Izmir", "San Francisco", "Istanbul", "Ankara", "Cupertino" ]

protocol SettingsViewControllerDelegate : class {
    func SendDataToViewController(info : Int) -> ()
}

class SettingsViewController: UIViewController {
    
    var selectedData:Int = -1
    @IBOutlet weak var cityPicker: UIPickerView!
    weak var delegate : SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityPicker.dataSource = self
        self.cityPicker.delegate = self
           }
    
    
    
   @IBAction func setCityButtonClicked(_ sender: Any) {
    self.delegate?.SendDataToViewController(info: selectedData)
    let all = self.navigationController!.viewControllers
    let vcB = all[all.count - 2] as! ViewController
        
    self.navigationController?.popToRootViewController(animated: true)
    vcB.determineCity()
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
        
        switch component {
        case 1:
            selectedData = component
        default:
            selectedData = component
        }
        
    }
}
