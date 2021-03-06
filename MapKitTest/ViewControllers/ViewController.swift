//
//  ViewController.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 4/25/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
//

import UIKit
import MapKit

// MARK: - Weather
struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    var main, icon: String
    var weatherDescription: String?
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription
        case icon
    }
    init(weatherDescription:String?, id: Int, main:String, icon:String) {
        self.weatherDescription = weatherDescription
        self.id = id
        self.main = main
        self.icon = icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}


struct defaultsKeys {
    static let SelectedMainCity = "City"
    static let SelectedTemperature = "Temperature"
}

protocol HandleMapSearch {
    func dropPinZoomIn(_ placemark: MKPlacemark)
}

class ViewController: UIViewController, UISearchBarDelegate {
    var selectedPin: MKPlacemark?
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBAction func infoButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "SettingsViewControllerSegue", sender: (Any).self)
    }
    @IBAction func mapTypeSegmentSelected(_ sender: Any)
    {
        switch (sender as AnyObject).selectedSegmentIndex {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .satellite
            default:
                mapView.mapType = .hybrid
            }
        }
   
    @IBAction func myLocationClicked(_ sender: Any) {
        mapView.setUserTrackingMode(.follow, animated: true)
        }
    
    var resultSearchController: UISearchController?
    private var bikeStations: [SFBikes] = []
    private var ferryStations: [IzmirVapur] = []
    override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view
    let defaults = UserDefaults.standard
    let stringOne = defaults.integer(forKey: defaultsKeys.SelectedMainCity)
        
    determineCity(input: stringOne)
    

    
    mapView.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.startUpdatingLocation()
        
    guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 0.01, longitudinalMeters: 0.01)
    mapView.setRegion(coordinateRegion, animated: true)
    mapView.setUserTrackingMode(.follow, animated: true)
        //Search Section
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        searchBar.sizeToFit()
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
      }
    
    // MARK: - Coordinate Variables
    fileprivate let locationManager : CLLocationManager = CLLocationManager ()
    func setPinUsingMKPointAnnotation(name:String, subtitle: String, locationname:CLLocationCoordinate2D ){
       let annotation = MKPointAnnotation()
       annotation.coordinate = locationname
       annotation.title = name
       annotation.subtitle = subtitle
       let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordinateRegion, animated: true)
       mapView.addAnnotation(annotation)
    }
    @IBAction func refreshClicked(_ sender: Any) {
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    // MARK: - Izmir Tram Stop Pins
    func IzmirTramPinsDraw(){
        let BostanliIsk = CLLocationCoordinate2D(latitude: 38.454609 , longitude: 27.098283)
           let CarsiIzban = CLLocationCoordinate2D(latitude:38.458105 , longitude: 27.094387)
           let VilayetEvi = CLLocationCoordinate2D(latitude:38.460535 , longitude: 27.090104)
           let SelcukYasar = CLLocationCoordinate2D(latitude:38.464175 , longitude: 27.086184)
           let Atakent = CLLocationCoordinate2D(latitude:38.468012 , longitude: 27.087788)
           let BilimMuzesi = CLLocationCoordinate2D(latitude:38.474204 , longitude: 27.082427)
           let AtaturkSporSalonu = CLLocationCoordinate2D(latitude:38.475412 , longitude: 27.074681)
        
        setPinUsingMKPointAnnotation(name: "Bostanli", subtitle: "Tramvay Istasyonu", locationname: BostanliIsk)
        setPinUsingMKPointAnnotation(name: "Carsi", subtitle: "Tramvay Istasyonu", locationname: CarsiIzban )
        setPinUsingMKPointAnnotation(name: "Vilayet Evi", subtitle: "Tramvay Istasyonu", locationname: VilayetEvi)
        setPinUsingMKPointAnnotation(name: "Selcuk Yasar", subtitle: "Tramvay Istasyonu",locationname: SelcukYasar)
        setPinUsingMKPointAnnotation(name: "Atakent", subtitle: "Tramvay Istasyonu", locationname: Atakent)
        setPinUsingMKPointAnnotation(name: "Bilim Muzesi", subtitle: "Tramvay Istasyonu", locationname: BilimMuzesi)
        setPinUsingMKPointAnnotation(name: "Mustafa Kemal Spor Salonu", subtitle: "Tramvay Istasyonu", locationname: AtaturkSporSalonu)
//        Lines Between Stops
        showRouteOnMap(pickupCoordinate: BostanliIsk, destinationCoordinate: CarsiIzban)
        showRouteOnMap(pickupCoordinate: CarsiIzban, destinationCoordinate: VilayetEvi)
        showRouteOnMap(pickupCoordinate: VilayetEvi, destinationCoordinate: SelcukYasar)
        showRouteOnMap(pickupCoordinate: SelcukYasar, destinationCoordinate: Atakent)
        showRouteOnMap(pickupCoordinate: Atakent, destinationCoordinate: BilimMuzesi)
        showRouteOnMap(pickupCoordinate: BilimMuzesi, destinationCoordinate: AtaturkSporSalonu)
        
    }
    
    func IzmirBisimPinsDraw() {
        let MavisehirBisim = CLLocationCoordinate2D(latitude: 38.4674834,longitude: 27.0793412)
        let BalikciBarinagi = CLLocationCoordinate2D(latitude: 38.465435, longitude: 27.0817107)
        let KarsiyakaIsk = CLLocationCoordinate2D(latitude:38.4552765126, longitude: 27.120318845)
        let Mavibahce = CLLocationCoordinate2D(latitude:38.4749864, longitude: 27.0747371)
        let BostanliSporTesisleri = CLLocationCoordinate2D(latitude:38.4622502557, longitude: 27.0849728096)
        let Yunuslar = CLLocationCoordinate2D(latitude:38.4511789658, longitude: 27.1041118947)
        let KSKEvlendirme = CLLocationCoordinate2D(latitude: 38.4494793514, longitude: 27.1105867977)
        let Churchill = CLLocationCoordinate2D(latitude: 38.456065695, longitude:27.0926334293)
        let BostanliIskBisim = CLLocationCoordinate2D(latitude: 38.45471, longitude: 27.096761)
        let inciraltiRekreasyon = CLLocationCoordinate2D(latitude: 38.4134047464, longitude: 27.0325753524)
        let sahilevleri1 = CLLocationCoordinate2D(latitude: 38.411389, longitude: 27.013472)
        let sahilevleri2 = CLLocationCoordinate2D(latitude: 38.406137, longitude: 26.996162)
        let inciraltiKent = CLLocationCoordinate2D(latitude: 38.4066894063, longitude: 27.0618320135)
        let uckuyularIskele = CLLocationCoordinate2D(latitude: 38.4047512791, longitude: 27.0701936867)
        let AdnanSaygun = CLLocationCoordinate2D(latitude: 38.4006949388, longitude: 27.0781865266)
        let GoztepeKopru = CLLocationCoordinate2D(latitude: 38.3992000613, longitude: 27.0837509082)
        let susuzDede = CLLocationCoordinate2D(latitude: 38.4021639086, longitude: 27.0930261205)
        let kopru = CLLocationCoordinate2D(latitude: 38.4062155783, longitude: 27.0987910553)
        let karantina = CLLocationCoordinate2D(latitude: 38.4090090197, longitude: 27.1089924616)
        let karatas = CLLocationCoordinate2D(latitude: 38.4116478229, longitude: 27.1201230494)
        let konakIskele = CLLocationCoordinate2D(latitude: 38.4187847458, longitude: 27.1264456215)
        let konakMetro = CLLocationCoordinate2D(latitude: 38.416539, longitude: 27.127547)
        let pasaportIskele = CLLocationCoordinate2D(latitude: 38.4275173482, longitude: 27.1325844103)
        let vasifCinar = CLLocationCoordinate2D(latitude: 38.4303211039, longitude: 27.1342384751)
        let AliCetinkaya = CLLocationCoordinate2D(latitude: 38.4340526994, longitude: 27.1380971058)
        let AlsancakIskele = CLLocationCoordinate2D(latitude: 38.4384639223, longitude: 27.1414140426)
        let liman = CLLocationCoordinate2D(latitude: 38.4421949873, longitude: 27.1432792183)
        let AlsancakGari = CLLocationCoordinate2D(latitude: 38.439948857, longitude: 27.1478470394)
        let MelesRekreasyon = CLLocationCoordinate2D(latitude: 38.4451831829, longitude: 27.1707578568)
        let Buzpisti1 = CLLocationCoordinate2D(latitude: 38.468382, longitude: 27.211666)
        let Buzpisti2 = CLLocationCoordinate2D(latitude: 38.46576, longitude: 27.207689)
        let BayrakliIskele = CLLocationCoordinate2D(latitude: 38.4635758915, longitude: 27.1627288532)
        let BayrakliNikah = CLLocationCoordinate2D(latitude: 38.4667637722, longitude: 27.158891294)
        let TuranIstasyonu = CLLocationCoordinate2D(latitude: 38.4671289884, longitude: 27.1495805948)
        let Kuscenneti = CLLocationCoordinate2D(latitude: 38.533134, longitude: 26.898589)
        let DogalYasam = CLLocationCoordinate2D(latitude: 38.487952, longitude: 26.958984)
        let AlaybeyTershane = CLLocationCoordinate2D(latitude: 38.460954, longitude: 27.127738)
        let FuarBasmane = CLLocationCoordinate2D(latitude: 38.424372, longitude: 27.143219)
        let FuarLozan = CLLocationCoordinate2D(latitude: 38.42975, longitude: 27.142266)
        let FuarMontro = CLLocationCoordinate2D(latitude: 38.427879, longitude: 27.14175)
        let ADBAirport = CLLocationCoordinate2D(latitude:38.297900,longitude:  27.153348)
        setPinUsingMKPointAnnotation(name: "Mavişehir", subtitle: "Bisim", locationname: MavisehirBisim)
        setPinUsingMKPointAnnotation(name: "Balıkçı Barinağı", subtitle: "Bisim", locationname: BalikciBarinagi)
        setPinUsingMKPointAnnotation(name: "Karşıyaka İskele", subtitle: "Bisim", locationname: KarsiyakaIsk)
        setPinUsingMKPointAnnotation(name: "Mavi Bahçe", subtitle: "Bisim", locationname: Mavibahce)
        setPinUsingMKPointAnnotation(name: "Bostanlı Spor Tesisleri", subtitle: "Bisim", locationname: BostanliSporTesisleri)
        setPinUsingMKPointAnnotation(name: "Yunuslar", subtitle: "Bisim", locationname: Yunuslar)
        setPinUsingMKPointAnnotation(name: "Evlendirme Dairesi", subtitle: "Bisim", locationname: KSKEvlendirme)
        setPinUsingMKPointAnnotation(name: "Churchill", subtitle: "Bisim", locationname: Churchill)
        setPinUsingMKPointAnnotation(name: "Bostanlı İskele", subtitle: "Bisim", locationname: BostanliIskBisim)
        setPinUsingMKPointAnnotation(name: "İnciralti Rekreasyon Alanı", subtitle: "Bisim", locationname: inciraltiRekreasyon)
        setPinUsingMKPointAnnotation(name: "Sahilevleri 1", subtitle: "Bisim", locationname: sahilevleri1)
        setPinUsingMKPointAnnotation(name: "Sahilevleri 2", subtitle: "Bisim", locationname: sahilevleri2)
        setPinUsingMKPointAnnotation(name: "İnciralti Kent Ormanı", subtitle: "Bisim", locationname: inciraltiKent)
        setPinUsingMKPointAnnotation(name: "Üçkuyular İskele", subtitle: "Bisim", locationname: uckuyularIskele)
        setPinUsingMKPointAnnotation(name: "Adnan Saygun", subtitle: "Bisim", locationname: AdnanSaygun)
        setPinUsingMKPointAnnotation(name: "Göztepe Koprü", subtitle: "Bisim", locationname: GoztepeKopru)
        setPinUsingMKPointAnnotation(name: "Susuzdede", subtitle: "Bisim", locationname: susuzDede)
        setPinUsingMKPointAnnotation(name: "Köprü", subtitle: "Bisim", locationname: kopru)
        setPinUsingMKPointAnnotation(name: "Karantina", subtitle: "Bisim", locationname: karantina)
        setPinUsingMKPointAnnotation(name: "Karataş", subtitle: "Bisim", locationname: karatas)
        setPinUsingMKPointAnnotation(name: "Konak İskele", subtitle: "Bisim", locationname: konakIskele)
        setPinUsingMKPointAnnotation(name: "Konak Metro", subtitle: "Bisim", locationname: konakMetro)
        setPinUsingMKPointAnnotation(name: "Pasaport İskele", subtitle: "Bisim", locationname: pasaportIskele)
        setPinUsingMKPointAnnotation(name: "Vasıf Çınar", subtitle: "Bisim", locationname: vasifCinar)
        setPinUsingMKPointAnnotation(name: "Ali Çetinkaya", subtitle: "Bisim", locationname: AliCetinkaya)
        setPinUsingMKPointAnnotation(name: "Alsancak İskele", subtitle: "Bisim", locationname: AlsancakIskele)
        setPinUsingMKPointAnnotation(name: "Alsancak Limanı", subtitle: "Bisim", locationname: liman)
        setPinUsingMKPointAnnotation(name: "Meles Rekreasyon Alanı", subtitle: "Bisim", locationname: MelesRekreasyon)
        setPinUsingMKPointAnnotation(name: "Buzpisti 1", subtitle: "Bisim", locationname: Buzpisti1)
        setPinUsingMKPointAnnotation(name: "Buzpisti 2", subtitle: "Bisim", locationname: Buzpisti2)
        setPinUsingMKPointAnnotation(name: "Bayraklı İskele", subtitle: "Bisim", locationname: BayrakliIskele)
        setPinUsingMKPointAnnotation(name: "Bayraklı Nikah Salonu", subtitle: "Bisim", locationname: BayrakliNikah)
        setPinUsingMKPointAnnotation(name: "Turan İstasyonu", subtitle: "Bisim", locationname: TuranIstasyonu)
        setPinUsingMKPointAnnotation(name: "Kuş Cenneti", subtitle: "Bisim", locationname: Kuscenneti)
        setPinUsingMKPointAnnotation(name: "Doğal Yaşam Parkı", subtitle: "Bisim", locationname: DogalYasam)
        setPinUsingMKPointAnnotation(name: "Alaybey Tershane", subtitle: "Bisim", locationname: AlaybeyTershane)
        setPinUsingMKPointAnnotation(name: "Fuar Basmane", subtitle: "Bisim", locationname: FuarBasmane)
        setPinUsingMKPointAnnotation(name: "Fuar Montrö", subtitle: "Bisim", locationname: FuarMontro)
        setPinUsingMKPointAnnotation(name: "Fuar Lozan", subtitle: "Bisim", locationname: FuarLozan)
        setPinUsingMKPointAnnotation(name: "Alsancak Garı", subtitle: "Bisim", locationname: AlsancakGari)
        
        setPinUsingMKPointAnnotation(name: "Adnan Menderes Airport", subtitle: "Airport", locationname: ADBAirport)
    }
    
    func AntalyaBikeDraw(){
        let konyaAlti = CLLocationCoordinate2D(latitude: 36.861438, longitude:30.637687)
        let OlbiaMeydan = CLLocationCoordinate2D(latitude: 36.876807,longitude:30.660607)
        let Varyant = CLLocationCoordinate2D(latitude:36.883149,longitude:30.674594)
        let AtaturkParki = CLLocationCoordinate2D(latitude:36.884746,longitude:30.687173)
        let KapaliYol = CLLocationCoordinate2D(latitude: 36.891254, longitude: 30.703221)
        let Isiklar = CLLocationCoordinate2D(latitude: 36.881224, longitude: 30.707737)
        let Sampi = CLLocationCoordinate2D(latitude: 36.872844, longitude: 30.718561)
        let DudenPark = CLLocationCoordinate2D(latitude: 36.85553, longitude: 30.780863)
        
        setPinUsingMKPointAnnotation(name: "Konyaaltı Meydan", subtitle: "ANTBIS", locationname: konyaAlti)
        setPinUsingMKPointAnnotation(name: "Olbia Meydan", subtitle: "ANTBIS", locationname: OlbiaMeydan)
        setPinUsingMKPointAnnotation(name: "Varyant", subtitle: "ANTBIS", locationname: Varyant)
        setPinUsingMKPointAnnotation(name: "Atatürk Parkı", subtitle: "ANTBIS", locationname: AtaturkParki)
        setPinUsingMKPointAnnotation(name: "Kapalı Yol", subtitle: "ANTBIS", locationname: KapaliYol)
        setPinUsingMKPointAnnotation(name: "Işıklar", subtitle: "ANTBIS", locationname: Isiklar)
        setPinUsingMKPointAnnotation(name: "Sampi Kavşağı", subtitle: "ANTBIS", locationname: Sampi)
        setPinUsingMKPointAnnotation(name: "Düden Park", subtitle: "ANTBIS", locationname: DudenPark)
        
        let defaults = UserDefaults.standard
        let stringTwo = defaults.integer(forKey: defaultsKeys.SelectedTemperature)
        let weatherC = "https://api.openweathermap.org/data/2.5/weather?id=323776&appid=2e179bfc031d24d3f8c4263261237b0b&units=metric"
        let weatherF = "https://api.openweathermap.org/data/2.5/weather?id=323776&appid=2e179bfc031d24d3f8c4263261237b0b&units=imperial"
        if stringTwo == 0{
        fetchWeather(urlinput: weatherC, requestedTempUnit: stringTwo)
        }
        if stringTwo == 1 {
            fetchWeather(urlinput: weatherF, requestedTempUnit: stringTwo)
        }
    }
    
    func determineCity(input: Int){
        let defaults = UserDefaults.standard
        switch input {
        case 1:
        print("Set Home City to Izmir")
        defaults.set(input, forKey: defaultsKeys.SelectedMainCity)
        clearMap()
        IzmirSelected()
        case 2:
        print("Set Home City to San Francisco Bay Area")
        defaults.set(input, forKey: defaultsKeys.SelectedMainCity)
        clearMap()
        SanFranciscoDraw()
        case 3:
        print("Set Home City to Istanbul")
        defaults.set(input, forKey: defaultsKeys.SelectedMainCity)
        clearMap()
        case 4:
        print("Set Home City to Ankara")
        defaults.set(input, forKey: defaultsKeys.SelectedMainCity)
        clearMap()
        case 5:
        print("Set Home City to Cupertino")
        defaults.set(input, forKey: defaultsKeys.SelectedMainCity)
        clearMap()
        case 6:
        print("Set Home City to Antalya")
        defaults.set(input, forKey: defaultsKeys.SelectedMainCity)
        clearMap()
        AntalyaBikeDraw()
        default:
            break
        }
        
    }
    
    func IzmirSelected()  {
        let defaults = UserDefaults.standard
        let stringTwo = defaults.integer(forKey: defaultsKeys.SelectedTemperature)
        let celsiusurl = "https://api.openweathermap.org/data/2.5/weather?id=311044&appid=2e179bfc031d24d3f8c4263261237b0b&units=metric"
        let fahrenheiturl = "https://api.openweathermap.org/data/2.5/weather?id=311044&appid=2e179bfc031d24d3f8c4263261237b0b&units=imperial"
        if stringTwo == 0{
        fetchWeather(urlinput: celsiusurl, requestedTempUnit: stringTwo)
        }
        if stringTwo == 1 {
            fetchWeather(urlinput: fahrenheiturl, requestedTempUnit: stringTwo)
        }
        IzmirBisimPinsDraw()
        IzmirTramPinsDraw()
        guard let fileName = Bundle.main.url(forResource: "izmirvapur", withExtension: "geojson"),
            let data = try? Data(contentsOf: fileName)
            
          else {
            return
        }
            do {
                 let SeaAnnotations = try MKGeoJSONDecoder()
                      .decode(data)
                      .compactMap { $0 as? MKGeoJSONFeature }
                    // 3
                    let validstations = SeaAnnotations.compactMap(IzmirVapur.init)
                    ferryStations.append(contentsOf: validstations)
                    mapView.addAnnotations(ferryStations)
                    
                  } catch {
                    // 5
                    print("Unexpected error: \(error).")
                  }
    }
    // MARK: - San Francisco Pins
    func SanFranciscoDraw(){
    let defaults = UserDefaults.standard
    let stringTwo = defaults.integer(forKey: defaultsKeys.SelectedTemperature)
    let celsius = "https://api.openweathermap.org/data/2.5/weather?id=5391959&appid=2e179bfc031d24d3f8c4263261237b0b&units=metric"
    let fahrenheit = "https://api.openweathermap.org/data/2.5/weather?id=5391959&appid=2e179bfc031d24d3f8c4263261237b0b&units=imperial"
    if stringTwo == 0 {
    fetchWeather(urlinput: celsius, requestedTempUnit: stringTwo)
    }
    if stringTwo == 1 {
        fetchWeather(urlinput: fahrenheit, requestedTempUnit: stringTwo)
    }
    guard let fileName = Bundle.main.url(forResource: "fordGoBike", withExtension: "geojson"),
        let data = try? Data(contentsOf: fileName)
        
      else {
        return
    }
        do {
             let bikeAnnotations = try MKGeoJSONDecoder()
                  .decode(data)
                  .compactMap { $0 as? MKGeoJSONFeature }
                // 3
                let validstations = bikeAnnotations.compactMap(SFBikes.init)
                bikeStations.append(contentsOf: validstations)
                mapView.addAnnotations(bikeStations)
                
              } catch {
                // 5
                print("Unexpected error: \(error).")
              }
    
    }
   // MARK: - Fetching Weather
    func fetchWeather(urlinput: String, requestedTempUnit: Int){
        
        if let url = URL(string: urlinput) {
            
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
                    let model = try decoder.decode(Weather.self, from: dataResponse)
                    print(model)
                    
                    if let temp = model.main.temp {
                       
                                        
                        DispatchQueue.main.async {
                            
                            if requestedTempUnit == 0 {
                                self.temperatureLabel.text = String(Int(temp)) + "°C"
                                if let status = model.weather.first {
                                    switch status.main {
                                    case "Clouds":
                                        if status.id == 801 {
                                        self.weatherImage.image = UIImage(named: "sunny_intervals")
                                        }
                                        if status.id == 802 {
                                        self.weatherImage.image = UIImage(named: "sunny_intervals")
                                        }
                                        if status.id == 803 {
                                        self.weatherImage.image = UIImage(named: "cloud")
                                        }
                                        if status.id == 804 {
                                        self.weatherImage.image = UIImage(named: "white_cloud")
                                        }
                                    case "Clear":
                                        self.weatherImage.image = UIImage(named: "sunny")
                                    case "Snow":
                                        self.weatherImage.image = UIImage(named: "snow")
                                    case "Rain":
                                        if status.id == 500 {
                                        self.weatherImage.image = UIImage(named: "rain")
                                        }
                                        if status.id == 501 {
                                        self.weatherImage.image = UIImage(named: "light_rain_showers")
                                        }
                                        if status.id == 502 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 503 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 504 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 511 {
                                        self.weatherImage.image = UIImage(named: "cloudy_with_sleet")
                                        }
                                        if status.id == 520 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 521 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 522 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }

                                    case "Thunderstorm":
                                        self.weatherImage.image = UIImage(named: "thunderstorms")
                                    case "Drizzle":
                                        self.weatherImage.image = UIImage(named: "cloudy_with_light_rain")
                                    default:
                                        break
                                    }
                                }
                            }
                            if requestedTempUnit == 1 {
                                self.temperatureLabel.text = String(Int(temp)) + "°F"
                                if let status = model.weather.first {
                                    switch status.main {
                                    case "Clouds":
                                        if status.id == 801 {
                                        self.weatherImage.image = UIImage(named: "sunny_intervals")
                                        }
                                        if status.id == 802 {
                                        self.weatherImage.image = UIImage(named: "sunny_intervals")
                                        }
                                        if status.id == 803 {
                                        self.weatherImage.image = UIImage(named: "cloud")
                                        }
                                        if status.id == 804 {
                                        self.weatherImage.image = UIImage(named: "white_cloud")
                                        }
                                    case "Clear":
                                        self.weatherImage.image = UIImage(named: "sunny")
                                    case "Snow":
                                        self.weatherImage.image = UIImage(named: "snow")
                                    case "Rain":
                                        if status.id == 500 {
                                        self.weatherImage.image = UIImage(named: "rain")
                                        }
                                        if status.id == 501 {
                                        self.weatherImage.image = UIImage(named: "light_rain_showers")
                                        }
                                        if status.id == 502 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 503 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 504 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 511 {
                                        self.weatherImage.image = UIImage(named: "cloudy_with_sleet")
                                        }
                                        if status.id == 520 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 521 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                        if status.id == 522 {
                                        self.weatherImage.image = UIImage(named: "heavy_rain_showers")
                                        }
                                    case "Thunderstorm":
                                        self.weatherImage.image = UIImage(named: "thunderstorms")
                                    case "Drizzle":
                                        self.weatherImage.image = UIImage(named: "cloudy_with_light_rain")
                                    default:
                                        break
                                    }
                                }
                            }
                        }
                      }
                }
                catch let parsingError {
                print("Error", parsingError)
                }
            }
            catch let parsingError {
            print("Error", parsingError)
            }
        }
        task.resume()
    }
}
    
    func clearMap() {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        self.mapView.removeOverlays(mapView.overlays)
    }

    // MARK: - showRouteOnMap

    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]

            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)

            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
}
   // MARK: - MKMapViewDelegate

}
extension ViewController: MKMapViewDelegate {
func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

    let renderer = MKPolylineRenderer(overlay: overlay)

    renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
    renderer.lineWidth = 5.0
    return renderer
}
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
      
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") {
            annotationView.annotation = annotation
            
            return annotationView
        } else {
            let annotationView = MKMarkerAnnotationView(annotation:annotation, reuseIdentifier: "")
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            if annotation.subtitle == "Bisim" || annotation.subtitle == "ANTBIS" || annotation.subtitle == "Ford GoBike" {
                annotationView.markerTintColor = .systemPurple
                annotationView.glyphImage = UIImage(named: "bike")
            }
            if annotation.subtitle == "Tramvay Istasyonu" {
                annotationView.markerTintColor = .systemGreen
                annotationView.glyphImage = UIImage(named: "tram")
            }
            if annotation.subtitle == "Search"  {
                annotationView.glyphImage = UIImage(systemName:"magnifyingglass" )
            }
            if (annotation.subtitle == "Airport"){
                annotationView.markerTintColor = .systemOrange
                annotationView.glyphImage = UIImage(named: "airport")
            }
            if (annotation.subtitle == "Ferry"){
                annotationView.markerTintColor = .systemBlue
                annotationView.glyphImage = UIImage(named: "ferry")
                
            }
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        }
       
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)  {
       if control == view.rightCalloutAccessoryView {
        if let annotation = view.annotation as? SFBikes {
                performSegue(withIdentifier: "moreDetail", sender: annotation)
        }
        if let annotation = view.annotation as? MKPointAnnotation {
        performSegue(withIdentifier: "moreDetail", sender: annotation)
        }
        if let annotation = view.annotation as? IzmirVapur {
                performSegue(withIdentifier: "showFerrySegue", sender: annotation)
        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let identifier = segue.identifier {
            if identifier == "moreDetail" {
            if let annotation = sender as? MKPointAnnotation {
                    let SecondVC = segue.destination as! moreDetail
                    SecondVC.incomingStationName = annotation.title
                    SecondVC.incomingStationType = annotation.subtitle
                    SecondVC.incomingCoordinate  = annotation.coordinate
                    }
            if let annotation = sender as? SFBikes {
                    let SecondVC = segue.destination as! moreDetail
                    SecondVC.incomingStationName = annotation.title
                    SecondVC.incomingStationType = annotation.subtitle
                    SecondVC.incomingCoordinate  = annotation.coordinate
                    }
            }
            if identifier == "showFerrySegue" {
                    if let annotation = sender as? IzmirVapur {
                    let SecondVC = segue.destination as! FerryViewController
                    SecondVC.incomingStationName = annotation.title
                    SecondVC.incomingStationType = annotation.subtitle
                    SecondVC.incomingCoordinate  = annotation.coordinate
                    }
                }
            }
        }
    }
extension ViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
//        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = "Search"
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
}

    class SFBikes: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(
    title: String?,
    coordinate: CLLocationCoordinate2D
    )
    {
    self.title = title
    self.coordinate = coordinate
    super.init()
    }
    
    var subtitle: String? {
      return "Ford GoBike"
    }
    init?(feature: MKGeoJSONFeature) {
         // 1
         guard
           let point = feature.geometry.first as? MKPointAnnotation,
           let propertiesData = feature.properties,
           let json = try? JSONSerialization.jsonObject(with: propertiesData),
           let properties = json as? [String: Any]
           else {
             return nil
         }

         // 3
         title = properties["name"] as? String
         coordinate = point.coordinate
         super.init()
       }
   
        var mapItem: MKMapItem? {
        guard let location = title else {
          return nil
        }
        let placemark = MKPlacemark(coordinate: coordinate)
            
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location
        return mapItem
            
        }
            }

class IzmirVapur: NSObject, MKAnnotation {
     var title: String?
     var coordinate: CLLocationCoordinate2D
     
     init(
     title: String?,
     coordinate: CLLocationCoordinate2D
     )
     {
     self.title = title
     self.coordinate = coordinate
     super.init()
     }
     
     var subtitle: String? {
       return "Ferry"
     }
     init?(feature: MKGeoJSONFeature) {
          // 1
          guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any]
            else {
              return nil
          }

          // 3
          title = properties["name"] as? String
          coordinate = point.coordinate
          super.init()
        }
    
         var mapItem: MKMapItem? {
         guard let location = title else {
           return nil
         }
         let placemark = MKPlacemark(coordinate: coordinate)
             
         let mapItem = MKMapItem(placemark: placemark)
         mapItem.name = location
         return mapItem
             
         }
}

