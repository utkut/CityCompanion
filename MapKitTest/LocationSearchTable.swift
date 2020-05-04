//
//  LocationSearchTable.swift
//  MapKitTest
//
//  Created by Utku Tarhan on 5/4/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
//

import Foundation
import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
//    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    guard let mapView = mapView,
        let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
        
    
    
    }
}
extension LocationSearchTable {
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return matchingItems.count
    }

}
