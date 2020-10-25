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

    /// 位置情報を取得
    private func getLocation() {
        let lm = LocationManager.sharedInstance
        lm.delegate = self
        lm.startUpdatingLocation()
    }

    /// 緯度経度を取得し地図の中央に設定する
    /// - Parameters:
    ///   - lat: 地図の中央の緯度
    ///   - lon: 地図の中央の経度
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
        // ユーザの現在地の緯度経度を取得し地図の中央に設定する
        self.moveMapView(lat: currentLocation.coordinate.latitude,
                         lon: currentLocation.coordinate.longitude)
    }
}
