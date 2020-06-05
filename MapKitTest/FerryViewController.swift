//
//  VapurViewController.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 6/5/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FerryViewController: UIViewController {

    @IBOutlet weak var FerryName: UILabel!
    @IBOutlet weak var StationType: UILabel!
    @IBOutlet weak var destinationPicker: UIPickerView!
    
    var IzmirFerryData = ["Bostanli", "Karsiyaka", "Alsancak", "Pasaport", "Konak", "Goztepe", "Uckuyular"]
    var incomingStationName: String?
    var incomingStationType: String?
    var incomingCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FerryName.text = incomingStationName
        StationType.text = incomingStationType
        self.destinationPicker.dataSource = self
        self.destinationPicker.delegate = self
    }
    
    @IBAction func getDirectionsClicked(_ sender: Any) {
        print("getting directions...")
        if let coordinate = incomingCoordinate {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
        mapItem.name = incomingStationName
        mapItem.openInMaps(launchOptions: options)
        }
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
