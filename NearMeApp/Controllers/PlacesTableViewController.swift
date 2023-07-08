//
//  PlacesTableViewController.swift
//  NearMeApp
//
//  Created by Enigma Kod on 07/07/2023.
//

import Foundation
import MapKit
import UIKit

class PlacesTableViewController: UITableViewController {
    var userLocation: CLLocation
    let places: [PlaceAnnotation]

    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row]

        // configure cell
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = "Distance KM"

        cell.contentConfiguration = content
        return cell
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
