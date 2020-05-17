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
        CompileData()
        stationName.sizeToFit()
        stationName.adjustsFontSizeToFitWidth = true
        stationName.lineBreakMode = .byWordWrapping
        stationType.sizeToFit()
        
		if(incomingStationType == "Airport"){
			let alertController = UIAlertController(title: "Alert", message: "This feature is not available yet.", preferredStyle: .alert)
			let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
				self.navigationController?.popToRootViewController(animated: true);
			}
			alertController.addAction(action1)
			self.present(alertController, animated: true, completion: nil)
					
		}
    }
    

// Function to read the frequency of Tram depending on the day.
func CompileData() {
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
	else{
		firstCellLabel.isHidden = true
		secondCellLabel.isHidden = true
		etaLabel.isHidden = true
		statusImageView.isHidden = true
		emptyBikeImageView.isHidden = true
		statusImageView.isHidden = true
		timestampLabel.isHidden = true
	}
	
    if (incomingStationType == "Bisim") {
		firstCellLabel.isHidden = false
		secondCellLabel.isHidden = false
		statusImageView.isHidden = false
		emptyBikeImageView.isHidden = false
		statusImageView.isHidden = false
		timestampLabel.isHidden = false
		let izmirurl = "https://api.citybik.es/v2/networks/baksi-bisim"
        timestamp()
        
		switch incomingStationName {
		case "Mavişehir":
			 getBikeData(stationName: "Mavişehir", urlinput: izmirurl)
		case "Balıkçı Barinağı":
			getBikeData(stationName: "Mavişehir Balıkçı Barınağı", urlinput: izmirurl)
		case "Karşıyaka İskele":
			getBikeData(stationName: "Karşıyaka iskele", urlinput: izmirurl)
		case "Mavi Bahçe":
			getBikeData(stationName: "Mavi Bahçe", urlinput: izmirurl)
		case "Bostanlı Spor Tesisleri":
			getBikeData(stationName: "Bostanlı Spor Tesisleri", urlinput: izmirurl)
		case "Yunuslar":
            getBikeData(stationName: "Yunuslar", urlinput: izmirurl)
		case "Evlendirme Dairesi":
			getBikeData(stationName: "Karşıyaka Evlendirme Dairesi", urlinput: izmirurl)
		case "Churchill":
			getBikeData(stationName: "Bostanlı Odağı", urlinput: izmirurl)
		case "Bostanlı İskele":
			getBikeData(stationName: "Bostanlı iskele ", urlinput: izmirurl)
		case "İnciralti Rekreasyon Alanı":
			getBikeData(stationName: "İnciraltı Rekreasyon Alanı", urlinput: izmirurl)
		case "Sahilevleri 1":
			getBikeData(stationName: "Sahilevleri 1", urlinput: izmirurl)
		case "Sahilevleri 2":
			getBikeData(stationName: "Sahilevleri 2", urlinput: izmirurl)
		case "İnciralti Kent Ormanı":
			getBikeData(stationName: "İnciraltı Kent Ormanı", urlinput: izmirurl)
		case "Üçkuyular İskele":
			getBikeData(stationName: "Üçkuyular İskelesi", urlinput: izmirurl)
		case "Adnan Saygun":
			getBikeData(stationName: "A.A Saygun", urlinput: izmirurl)
		case "Göztepe Koprü":
			getBikeData(stationName: "Göztepe Köprü", urlinput: izmirurl)
		case "Susuzdede":
			getBikeData(stationName: "Susuzdede", urlinput: izmirurl)
		case "Köprü":
			getBikeData(stationName: "Köprü", urlinput: izmirurl)
		case "Karantina":
			getBikeData(stationName: "Karantina", urlinput: izmirurl)
		case "Karataş":
			getBikeData(stationName: "Karataş", urlinput: izmirurl)
		case "Konak İskele":
            getBikeData(stationName: "Konak İskele", urlinput: izmirurl)
		case "Konak Metro":
			getBikeData(stationName: "Konak Metro", urlinput: izmirurl)
		case "Pasaport İskele":
			getBikeData(stationName: "Pasaport İskele", urlinput: izmirurl)
		case "Vasıf Çınar":
			getBikeData(stationName: "Vasıf Çınar", urlinput: izmirurl)
		case "Ali Çetinkaya":
			getBikeData(stationName: "Ali Çetinkaya Bulvarı", urlinput: izmirurl)
		case "Alsancak İskele":
			getBikeData(stationName: "Alsancak İskele", urlinput: izmirurl)
		case "Alsancak Gari":
			getBikeData(stationName: "Alsancak Gari", urlinput: izmirurl)
		case "":
			getBikeData(stationName: "", urlinput: izmirurl)
		case "Alsancak Limanı":
			 getBikeData(stationName: "Liman", urlinput: izmirurl)
		case "Meles Rekreasyon Alanı":
			getBikeData(stationName: "Meles Rekreasyon Alanı", urlinput: izmirurl)
		case "Buzpisti 1":
            getBikeData(stationName: "Buz Pisti 1", urlinput: izmirurl)
		case "Buzpisti 2":
            getBikeData(stationName: "Buz Pisti 2", urlinput: izmirurl)
		case "Bayraklı İskele":
            getBikeData(stationName: "Bayraklı İskele", urlinput: izmirurl)
		case "Bayraklı Nikah Salonu":
            getBikeData(stationName: "Bayraklı Nikah Salonu", urlinput: izmirurl)
		case "Turan İstasyonu":
            getBikeData(stationName: "İzban Turan İstasyonu", urlinput: izmirurl)
		case "Kuş Cenneti":
            getBikeData(stationName: "Kuş Cenneti", urlinput: izmirurl)
		case "Doğal Yaşam Parkı":
            getBikeData(stationName: "Doğal Yaşam Parkı", urlinput: izmirurl)
		case "Alaybey Tershane":
            getBikeData(stationName: "Alaybey Tershane", urlinput: izmirurl)
		case "Fuar Basmane":
            getBikeData(stationName: "Fuar Basmane", urlinput: izmirurl)
		case "Fuar Montrö":
            getBikeData(stationName: "Fuar Montrö", urlinput: izmirurl)

		default:
			print("No Station Found.")
		}
    }
	
	if (incomingStationType == "Airport"){
	}
	
	if incomingStationType == "ANTBIS" {
			firstCellLabel.isHidden = false
			secondCellLabel.isHidden = false
			statusImageView.isHidden = false
			etaLabel.isHidden = false
			emptyBikeImageView.isHidden = false
			statusImageView.isHidden = false
			timestampLabel.isHidden = false
			let url = "https://api.citybik.es/v2/networks/baksi-antalya"
			timestamp()
			switch incomingStationName {
			case "Konyaaltı Meydan":
				getBikeData(stationName: "Konyaaltı Meydan", urlinput: url)
			case "Olbia Meydani":
				getBikeData(stationName: "Olbia Meydan", urlinput: url)
			case "Varyant":
				getBikeData(stationName: "Varyant", urlinput: url)
			case "Ataturk Parki":
				getBikeData(stationName: "Atatürk Parkı", urlinput: url)
			case "Kapalı Yol":
				getBikeData(stationName: "Kapalı Yol", urlinput: url)
			case "Işıklar":
				getBikeData(stationName: "Işıklar", urlinput: url)
			case "Sampi Kavşağı":
				getBikeData(stationName: "Sampi Kavşağı", urlinput: url)
			case "Düden Park":
				getBikeData(stationName: "Düden Park", urlinput: url)
			default:
				print("Station Not Found")
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
    
   func getBikeData(stationName:String, urlinput:String){
   if let url = URL(string: urlinput){
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
    
    func getAirportData(){
	// Work Under Progress, until a Airport arrival-departure API can be sourced.
    }
    
}
