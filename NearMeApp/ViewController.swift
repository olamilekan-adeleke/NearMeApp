//
//  ViewController.swift
//  NearMeApp
//
//  Created by Enigma Kod on 02/07/2023.
//

import MapKit
import UIKit

class ViewController: UIViewController {
    private var places: [PlaceAnnotation] = []
    var locationManager: CLLocationManager?
    
    lazy var map: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = .white
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.returnKeyType = .go
        return searchTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Location Manager
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
        
        setUpUi()
    }
    
    private func setUpUi() {
        view.addSubview(searchTextField)
        view.addSubview(map)
        view.bringSubviewToFront(searchTextField)
        
        setUpMapLayout()
        setUpTextFieldLayout()
    }
    
    private func setUpMapLayout() {
        NSLayoutConstraint.activate([
            map.widthAnchor.constraint(equalTo: view.widthAnchor),
            map.heightAnchor.constraint(equalTo: view.heightAnchor),
            map.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            map.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setUpTextFieldLayout() {
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
        ])
    }
    
    private func findNearByPlaces(by query: String) {
        // clear all annotations
        map.removeAnnotations(map.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else { return }
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { self?.map.addAnnotation($0) }
            
            if let places = self?.places {
                self?.showPlacesListSheet(places: places)
            }
        }
    }
    
    private func showPlacesListSheet(places: [PlaceAnnotation]) {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        let placesTVC = PlacesTableViewController(userLocation: location, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTVC, animated: true)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    private func clearSelectedAnnotations() {
        places = places.map { place in
            place.isSelected = false
            return place
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        clearSelectedAnnotations()
        
        guard let selectedAnnotation: PlaceAnnotation = annotation as? PlaceAnnotation else { return }
        let placeAnnotation = places.first(where: { $0.id == selectedAnnotation.id })
        placeAnnotation?.isSelected = true
        showPlacesListSheet(places: places)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            findNearByPlaces(by: text)
        }

        return true
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        chechLocationAuth()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    private func chechLocationAuth() {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }

        switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
                map.setRegion(region, animated: true)
            case .denied:
                print("Location Denied")
            case .notDetermined, .restricted:
                print("Location Not Determined Or Restriiced")
            default:
                print("Locaation Unknown")
        }
    }
}
