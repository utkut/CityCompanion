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
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        IzmirTramPinsDraw()
        mapView.setUserTrackingMode(.follow, animated: true)
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
    let BostanliIsk = CLLocationCoordinate2D(latitude: 38.454609 , longitude: 27.098283)
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
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Bostanli", locationname: BostanliIsk)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Carsi", locationname: CarsiIzban )
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Vilayet Evi", locationname: VilayetEvi)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Selcuk Yasar",
                                     locationname: SelcukYasar)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Atakent", locationname: Atakent)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Bilim Muzesi", locationname: BilimMuzesi)
        setPinUsingMKPointAnnotation(name: "IZBAN", subtitle: "Mustafa Kemal Spor Salonu", locationname: AtaturkSporSalonu)
//        Lines Between Stops
        showRouteOnMap(pickupCoordinate: CarsiIzban, destinationCoordinate: VilayetEvi)
        showRouteOnMap(pickupCoordinate: VilayetEvi, destinationCoordinate: SelcukYasar)
        showRouteOnMap(pickupCoordinate: SelcukYasar, destinationCoordinate: Atakent)
        showRouteOnMap(pickupCoordinate: Atakent, destinationCoordinate: BilimMuzesi)
        showRouteOnMap(pickupCoordinate: BilimMuzesi, destinationCoordinate: AtaturkSporSalonu)
        
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

    }
