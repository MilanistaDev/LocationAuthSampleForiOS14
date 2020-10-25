//
//  MapViewController.swift
//  LocationAuthSample
//
//  Created by Takuya Aso on 2020/10/25.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }

    private func getLocation() {
        let lm = LocationManager.sharedInstance
        lm.delegate = self
        lm.startUpdatingLocation()
    }

    private func moveMapView(lat: Double, lon: Double) {
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = lat
        coordinate.longitude = lon
        self.mapView.setCenter(coordinate, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
    }
}

extension MapViewController: LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        // move to center of map
        self.moveMapView(lat: currentLocation.coordinate.latitude,
                         lon: currentLocation.coordinate.longitude)
    }
}
