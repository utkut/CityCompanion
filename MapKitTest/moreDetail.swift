//
//  moreDetail.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 4/26/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
//

import Foundation
import UIKit

class moreDetail : UIViewController {
    
    struct Stations: Codable {
        let company: [String]
        let href: String
        let id: String
        let location: LocationJson
        let name: String
        let stations: [Station]
        
        init(company:[String] , href:String, id:String, location:LocationJson, name:String, stations:[Station] )  {
            self.company = company
            self.href = href
            self.id = id
            self.location = location
            self.name = name
            self.stations = stations
        }

    }


    struct Station: Codable {
        let empty_slots: Int
        let extra: Extra
        let free_bikes: Int
        let id: String
        let latitude: Double
        let longitude: Double
        let name: String
        let timestamp: String

        public init?(empty_slots:Int, free_bikes:Int, id:String) {
            self.empty_slots = empty_slots
            self.id = id
            self.free_bikes = free_bikes
            
            return nil
        }
        
    }

    struct ResponseJSON: Codable {
        let network: Stations
    }

    struct LocationJson: Codable {
        let city: String
        let country: String
        let latitude: Double
        let longitude: Double
        init(city: String, country:String, latitude:Double, longitude:Double) {
            self.city = city
            self.country = country
            self.latitude = latitude
            self.longitude = longitude
        }
    }


    struct Extra: Codable {
        let slots: Int
        let status: String
        let uid: String
        
        init(slots:Int, status: String, uid: String) {
            self.slots = slots
            self.status = status
            self.uid = uid
        }
        
    }
    
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
    if (incomingStationType == "Tramvay Istasyonu"){
        
        if (dayInWeek == "Saturday" || dayInWeek == "Sunday"){
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
    if (incomingStationType == "Bisim"){
        
        if (incomingStationName == "Mavisehir"){
            getBikeData(stationName: "Mavişehir")
            
        }
    }
    
    
    
}
    func getBikeData(stationName:String){

   guard let url = URL(string: "https://api.citybik.es//v2/networks/baksi-bisim")
    else {
        print("Failed to Reach to the Bisim Data.")
    return
    
        }

   let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
           guard let dataResponse = data, error == nil else {
           print(error?.localizedDescription ?? "Response Error")
           return
       }
       do {
           //here dataResponse received from a network request
           let jsonResponse = try JSONSerialization.jsonObject(with:
                                  dataResponse, options: [])
           print(jsonResponse) //Response result


           do {
               //here dataResponse received from a network request
               let decoder = JSONDecoder()
               //Decode JSON Response Data
            
            let model = try decoder.decode(ResponseJSON.self, from: dataResponse)
            print(model)//Output - 1221
            
            if let station = model.network.stations.first(where: { $0.name == stationName }) {
            //get the properties of station here as per requirement
                let emptySlots = station.empty_slots
                let freeBikes = station.free_bikes
                let Status = station.extra.status
                print(emptySlots, freeBikes, Status)
                
            }
           }
           catch let parsingError {
               print("Error", parsingError)
           }

        } catch let parsingError {
           print("Error", parsingError)
        }
    
   }
   task.resume()
    

 }
}
