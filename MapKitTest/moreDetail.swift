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
import MapKit
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
    
    @IBAction func getDirectionsClicked(_ sender: Any) {
       getDirections()
    }
    
    var incomingStationName: String?
    var incomingStationType: String?
    var incomingCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationName.text = incomingStationName
        stationType.text = incomingStationType
        getTramFrequency()
        stationName.sizeToFit()
        stationName.adjustsFontSizeToFitWidth = true
        stationName.lineBreakMode = .byWordWrapping
        stationType.sizeToFit()
        
		if(incomingStationType == "Airport"){
			let alertController = UIAlertController(title: "Alert", message: "This feature is not available yet.", preferredStyle: .alert)
			let action1 = UIAlertAction(title: "OK", style: .default) { (_:UIAlertAction) in
				self.navigationController?.popToRootViewController(animated: true)
			}
			alertController.addAction(action1)
			self.present(alertController, animated: true, completion: nil)
					
		}
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
        
        if (incomingStationName == "Mavişehir"){
            getBikeData(stationName: "Mavişehir")
        }
        if (incomingStationName == "Balıkçı Barinağı"){
            getBikeData(stationName: "Mavişehir Balıkçı Barınağı")
        }
        if (incomingStationName == "Karşıyaka İskele"){
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
        if incomingStationName == "Bostanlı İskele" {
            getBikeData(stationName: "Bostanlı iskele ")
        }
        if incomingStationName == "İnciralti Rekreasyon Alanı" {
            getBikeData(stationName: "İnciraltı Rekreasyon Alanı")
        }
        if incomingStationName == "Sahilevleri 1" {
            getBikeData(stationName: "Sahilevleri 1")
        }
        if incomingStationName == "Sahilevleri 2"{
            getBikeData(stationName: "Sahilevleri 2")
        }
        if incomingStationName == "İnciralti Kent Ormanı"{
            getBikeData(stationName: "İnciraltı Kent Ormanı")
        }
        if incomingStationName == "Üçkuyular İskele"{
            getBikeData(stationName: "Üçkuyular İskelesi")
        }
        if incomingStationName == "Adnan Saygun" {
            getBikeData(stationName: "A.A Saygun")
        }
        if incomingStationName == "Göztepe Koprü" {
            getBikeData(stationName: "Göztepe Köprü")
        }
        if incomingStationName == "Susuzdede" {
            getBikeData(stationName: "Susuzdede")
        }
        if incomingStationName == "Köprü" {
            getBikeData(stationName: "Köprü")
        }
        if incomingStationName == "Karantina" {
            getBikeData(stationName: "Karantina")
        }
        if incomingStationName == "Karataş"{
            getBikeData(stationName: "Karataş")
        }
        if incomingStationName == "Konak İskele" {
            getBikeData(stationName: "Konak İskele")
        }
        if incomingStationName == "Konak Metro" {
            getBikeData(stationName: "Konak Metro")
        }
        if incomingStationName == "Pasaport İskele" {
            getBikeData(stationName: "Pasaport İskele")
        }
        if incomingStationName == "Vasıf Çınar" {
            getBikeData(stationName: "Vasıf Çınar")
        }
        if incomingStationName == "Ali Çetinkaya" {
            getBikeData(stationName: "Ali Çetinkaya Bulvarı")
        }
        if incomingStationName == "Alsancak İskele" {
            getBikeData(stationName: "Alsancak İskele")
        }
        if incomingStationName == "Konak Metro" {
            getBikeData(stationName: "Konak Metro")
        }
        if incomingStationName == "Pasaport İskele" {
            getBikeData(stationName: "Pasaport İskele")
        }
        if incomingStationName == "Alsancak Limanı" {
            getBikeData(stationName: "Liman")
        }
        if incomingStationName == "Meles Rekreasyon Alanı" {
            getBikeData(stationName: "Meles Rekreasyon Alanı")
        }
        if incomingStationName == "Buzpisti 1" {
            getBikeData(stationName: "Buz Pisti 1")
        }
        if incomingStationName == "Buzpisti 2" {
            getBikeData(stationName: "Buz Pisti 2")
        }
        if incomingStationName == "Bayraklı İskele" {
            getBikeData(stationName: "Bayraklı İskele")
        }
        if incomingStationName == "Bayraklı Nikah Salonu" {
            getBikeData(stationName: "Bayraklı Nikah Salonu")
        }
        if incomingStationName == "Turan İstasyonu" {
            getBikeData(stationName: "İzban Turan İstasyonu")
        }
        if incomingStationName == "Kuş Cenneti" {
            getBikeData(stationName: "Kuş Cenneti")
        }
        if incomingStationName == "Doğal Yaşam Parkı" {
            getBikeData(stationName: "Doğal Yaşam Parkı")
        }
        if incomingStationName == "Alaybey Tershane" {
            getBikeData(stationName: "Alaybey Tershane")
        }
        if incomingStationName == "Fuar Basmane" {
            getBikeData(stationName: "Fuar Basmane")
        }
        if incomingStationName == "Fuar Montrö" {
            getBikeData(stationName: "Fuar Montrö")
        }
        
        if (incomingStationType == "Airport"){
            
		
        }
        
        
        
        
        
    }
    else{
        firstCellLabel.isHidden = true
        secondCellLabel.isHidden = true
        etaLabel.isHidden = true
        statusImageView.isHidden = true
        emptyBikeImageView.isHidden = true
        statusImageView.isHidden = true
        timestampLabel.isHidden = true

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
    
    func getDirections() {
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
    
    func getBikeData(stationName:String){

    if let url = URL(string: "https://api.citybik.es//v2/networks/baksi-bisim"){
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
    
    func getAirportData(){
	// Work Under Progress, until a Airport arrival-departure API can be sourced.
    }
    
}
