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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(.follow, animated: true)
        IzmirTramPinsDraw()
        
            }

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapType: UISegmentedControl!
    
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
    
    //MARK:- Coordinate Variables
    fileprivate let locationManager : CLLocationManager = CLLocationManager ()
    let CarsiIzban = CLLocationCoordinate2D(latitude:38.458105 , longitude: 27.094387)
    let VilayetEvi = CLLocationCoordinate2D(latitude:38.460535 , longitude: 27.090104)
    let SelcukYasar = CLLocationCoordinate2D(latitude:38.464175 , longitude: 27.086184)
    let Atakent = CLLocationCoordinate2D(latitude:38.468012 , longitude: 27.087788)
    let BilimMuzesi = CLLocationCoordinate2D(latitude:38.474204 , longitude: 27.082427)
    let AtaturkSporSalonu = CLLocationCoordinate2D(latitude:38.475412 , longitude: 27.074681)
    
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
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Carsi", locationname: CarsiIzban )
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Vilayet Evi", locationname: VilayetEvi)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Selcuk Yasar",
                                     locationname: SelcukYasar)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Atakent", locationname: Atakent)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Bilim Muzesi", locationname: BilimMuzesi)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Mustafa Kemal Spor Salonu", locationname: AtaturkSporSalonu)
    }
    
    
 //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
