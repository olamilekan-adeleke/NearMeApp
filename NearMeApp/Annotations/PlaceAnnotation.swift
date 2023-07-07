//
//  PlaceAnnotation.swift
//  NearMeApp
//
//  Created by Enigma Kod on 07/07/2023.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false

    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
    var name: String { mapItem.name ?? ""}
    var phone: String { mapItem.phoneNumber ?? ""}
    var location: CLLocation {mapItem.placemark.location ?? }
}
