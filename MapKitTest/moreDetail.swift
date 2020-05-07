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

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var firstCellLabel: UILabel!
    @IBOutlet weak var secondCellLabel: UILabel!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var stationType: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var emptyBikeImageView: UIImageView!
    @IBOutlet weak var freeBikeImageView: UIImageView!
    
    
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
        
        firstCellLabel.isHidden = true
        secondCellLabel.isHidden = true
        statusImageView.isHidden = false
        emptyBikeImageView.isHidden = true
        freeBikeImageView.isHidden = true
        
        if (dayInWeek == "Saturday" || dayInWeek == "Sunday"){
            etaLabel.text = "No Lines Running Today."
            timestamp()
        }
        else{
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "HH.mm"
            let dayinHours = dateFormatter.string(from: date)
            
            if let myTime = Double(dayinHours){
                if (myTime >= 06.00 && myTime < 10.00){
                    etaLabel.text = "Tram is every 7.5 minutes. "
                    statusImageView.image = UIImage(named: "available.png")
                    timestamp()
                }
                if (myTime >= 10.00 && myTime < 16.00){
                    etaLabel.text = "Tram is every 40 minutes. "
                    statusImageView.image = UIImage(named: "available.png")
                    timestamp()
                }
                if (myTime >= 16.00 && myTime < 21.00){
                    etaLabel.text = "Tram is every 10 minutes. "
                    statusImageView.image = UIImage(named: "available.png")
                    timestamp()
                }
                if (myTime >= 21.00 && myTime < 23.59){
                    etaLabel.text = "Tram is every 40 minutes. "
                    statusImageView.image = UIImage(named: "available.png")
                    timestamp()
                }
                if (myTime >= 0 && myTime < 5.59){
                    etaLabel.text = "Tram is Not Running at the Moment. "
                    print(myTime)
                    statusImageView.image = UIImage(named: "unavailable.png")
                    timestamp()
                }
            }
            else{
                etaLabel.text = "Unable to Retrieve. "
                
            }
        }
    }
    if (incomingStationType == "Bisim"){
        firstCellLabel.isHidden = false
        secondCellLabel.isHidden = false
        timestamp()
        
        if (incomingStationName == "Mavisehir"){
            getBikeData(stationName: "Mavişehir")
        }
        if (incomingStationName == "Balikci Barinagi"){
            getBikeData(stationName: "Mavişehir Balıkçı Barınağı")
        }
        if (incomingStationName == "Karşıyaka Iskele"){
            getBikeData(stationName: "Karşıyaka iskele")
        }
        if(incomingStationName == "Mavi Bahçe"){
            getBikeData(stationName: "Mavi Bahçe")
        }
        if(incomingStationName == "Bostanlı Spor Tesisleri"){
            getBikeData(stationName: "Bostanlı Spor Tesisleri")
        }
        if(incomingStationName == "Yunuslar"){
            getBikeData(stationName: "Yunuslar")
        }
        if(incomingStationName == "Evlendirme Dairesi"){
            getBikeData(stationName: "Karşıyaka Evlendirme Dairesi")
        }
        if (incomingStationName == "Churchill") {
            getBikeData(stationName: "Bostanlı Odağı")
        }
        if incomingStationName == "Bostanli Iskele" {
            getBikeData(stationName: "Bostanlı iskele ")
        }
    }
    
    
    
}
    func timestamp(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeinhms = dateFormatter.string(from: date)
        let timestamp = String(timeinhms)
        self.timestampLabel.text! = timestamp
    }
    
    func getBikeData(stationName:String){

    if let url = URL(string: "https://api.citybik.es//v2/networks/baksi-bisim"){
   let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                DispatchQueue.main.async {
//                    self.emptySlotsLabel.text = String(station.empty_slots)
//                    self.freeBikesLabel.text = String(station.free_bikes)
                 
                    self.firstCellLabel.text = "Empty Bike Slots: " + String(station.empty_slots)
                    self.secondCellLabel.text = "Free Bikes: " + String(station.free_bikes)
                    self.etaLabel.text = "Station Status: " + station.extra.status
//                    Status Location Icons
                    if (station.extra.status == "Active"){
                        self.statusImageView.image = UIImage(named: "available.png")
                        if (station.empty_slots == 0) {
                            self.emptyBikeImageView.image = UIImage(named: "unavailable.png")
                        }
                        else{
                            self.emptyBikeImageView.image = UIImage(named: "available.png")
                        }
                        if (station.free_bikes == 0){
                            self.freeBikeImageView.image = UIImage(named: "unavailable.png")
                        }
                        else{
                            self.freeBikeImageView.image = UIImage(named: "available.png")
                        }
                    }
                    else{
                        self.statusImageView.image = UIImage(named: "unavailable.png")
                    }
                
                }
            
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
    
}
