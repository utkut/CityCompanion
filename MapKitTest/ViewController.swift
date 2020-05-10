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

protocol HandleMapSearch {
    func dropPinZoomIn(_ placemark: MKPlacemark)
}

class ViewController: UIViewController, UISearchBarDelegate{

    var selectedPin: MKPlacemark?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBAction func infoButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "infoViewControllerSegue", sender: (Any).self)
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
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view
    mapView.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.startUpdatingLocation()
    IzmirTramPinsDraw()
    IzmirBisimPinsDraw()
    mapView.setUserTrackingMode(.follow, animated: true)
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
      }
    @objc func getDirections() {
          if let selectedPin = selectedPin {
              let mapItem = MKMapItem(placemark: selectedPin)
              let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
              mapItem.openInMaps(launchOptions: launchOptions)
          }
      }

    
    //MARK: - Coordinate Variables
    fileprivate let locationManager : CLLocationManager = CLLocationManager ()
    let BostanliIsk = CLLocationCoordinate2D(latitude: 38.454609 , longitude: 27.098283)
    let CarsiIzban = CLLocationCoordinate2D(latitude:38.458105 , longitude: 27.094387)
    let VilayetEvi = CLLocationCoordinate2D(latitude:38.460535 , longitude: 27.090104)
    let SelcukYasar = CLLocationCoordinate2D(latitude:38.464175 , longitude: 27.086184)
    let Atakent = CLLocationCoordinate2D(latitude:38.468012 , longitude: 27.087788)
    let BilimMuzesi = CLLocationCoordinate2D(latitude:38.474204 , longitude: 27.082427)
    let AtaturkSporSalonu = CLLocationCoordinate2D(latitude:38.475412 , longitude: 27.074681)
    
    // Bisim Variables
    
    let MavisehirBisim = CLLocationCoordinate2D(latitude: 38.4674834,longitude: 27.0793412)
    let BalikciBarinagi = CLLocationCoordinate2D(latitude: 38.465435, longitude: 27.0817107)
    let KarsiyakaIsk = CLLocationCoordinate2D(latitude:38.4552765126, longitude: 27.120318845)
    let Mavibahce = CLLocationCoordinate2D(latitude:38.4749864, longitude: 27.0747371)
    let BostanliSporTesisleri = CLLocationCoordinate2D(latitude:38.4622502557, longitude: 27.0849728096)
    let Yunuslar = CLLocationCoordinate2D(latitude:38.4511789658, longitude: 27.1041118947)
    let KSKEvlendirme = CLLocationCoordinate2D(latitude: 38.4494793514, longitude: 27.1105867977)
    let Churchill = CLLocationCoordinate2D(latitude: 38.456065695, longitude:27.0926334293)
    let BostanliIskBisim = CLLocationCoordinate2D(latitude: 38.45471, longitude: 27.096761)
    func setPinUsingMKPointAnnotation(name:String, subtitle: String, locationname:CLLocationCoordinate2D ){
       let annotation = MKPointAnnotation()
       annotation.coordinate = locationname
       annotation.title = name
       annotation.subtitle = subtitle
        
       let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordinateRegion, animated: true)
       mapView.addAnnotation(annotation)
    }
    
    //MARK: - Izmir Tram Stop Pins
    func IzmirTramPinsDraw(){
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
        
        setPinUsingMKPointAnnotation(name: "Mavisehir", subtitle: "Bisim", locationname: MavisehirBisim)
        setPinUsingMKPointAnnotation(name: "Balikci Barinagi", subtitle: "Bisim", locationname: BalikciBarinagi)
        setPinUsingMKPointAnnotation(name: "Karşıyaka Iskele", subtitle: "Bisim", locationname: KarsiyakaIsk)
        setPinUsingMKPointAnnotation(name:  "Mavi Bahçe", subtitle: "Bisim", locationname: Mavibahce)
        setPinUsingMKPointAnnotation(name: "Bostanlı Spor Tesisleri", subtitle: "Bisim", locationname: BostanliSporTesisleri)
        setPinUsingMKPointAnnotation(name: "Yunuslar", subtitle: "Bisim", locationname: Yunuslar)
        setPinUsingMKPointAnnotation(name: "Evlendirme Dairesi", subtitle: "Bisim", locationname: KSKEvlendirme)
        setPinUsingMKPointAnnotation(name: "Churchill", subtitle: "Bisim", locationname: Churchill)
        setPinUsingMKPointAnnotation(name: "Bostanli Iskele", subtitle: "Bisim", locationname: BostanliIskBisim)
        
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

//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

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

    // MARK: - MKMapViewDelegate

}
 

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
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier: "")
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
           
            if annotation.subtitle == "Bisim" {
                annotationView.pinTintColor = .systemBlue
            }
            if annotation.subtitle == "Tramvay Istasyonu" {
                annotationView.pinTintColor = .systemGreen
            }
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        }
       
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)  {
       if control == view.rightCalloutAccessoryView {
        if let annotation = view.annotation as? MKPointAnnotation {
            performSegue(withIdentifier: "moreDetail", sender: annotation)
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
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
        button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)

    }
}

