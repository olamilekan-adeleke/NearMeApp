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
    var places: [PlaceAnnotation]

    init(userLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        self.places.swapAt(selectedAnnotationIndex ?? 0, 0)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let placeDetailVC = PlaceDetailViewController(place: place)
        present(placeDetailVC, animated: true)
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
        content.secondaryText = getDistance(from: userLocation, to: place.location)

        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? UIColor.systemTeal : UIColor.clear
        return cell
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlacesTableViewController {
    private var selectedAnnotationIndex: Int? {
        places.firstIndex(where: { $0.isSelected == true })
    }

    private func getDistance(from: CLLocation, to: CLLocation) -> String {
        let distance: CLLocationDistance = from.distance(from: to)
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.formatted()
    }
}
