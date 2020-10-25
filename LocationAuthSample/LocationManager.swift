//
//  LocationManager.swift
//  Memories
//
//  Created by Takuya Aso on 2020/08/26.
//  Copyright © 2020 Takuya Aso. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func tracingLocation(currentLocation: CLLocation)
    //func tracingLocationDidFailWithError(error: Error)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation!
    weak var delegate: LocationServiceDelegate?

    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        return instance
    }()

    // MARK: - Initialized
    override init() {
        super.init()

        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else { return }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    // MARK: - Private Method

    private func updateLocation(currentLocation: CLLocation) {
        guard let delegate = self.delegate else { return }
        delegate.tracingLocation(currentLocation: currentLocation)
    }

    private func updateLocationDidFailWithError(error: Error) {
        //guard let delegate = self.delegate else { return }
        //delegate.tracingLocationDidFailWithError(error: error)
    }

    /// 位置情報の精度許可ステータスがreducedAccuracyだったらfullAccuracyにできるように許可を求める
    func requestFullAccuracy() {
        if #available(iOS 14.0, *) {
            if self.locationManager?.accuracyAuthorization == .reducedAccuracy {
                self.locationManager?.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "WantsToPreciseLocForNotice") { _ in
                    if self.locationManager?.accuracyAuthorization == .fullAccuracy {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "NotifyChange"), object: nil)
                        //self.startUpdatingLocation()
                    }
                }
            }
        }
    }

    /// 位置情報の精度が低いかどうかを判定
    func isReducedAccuracy() -> Bool {
        if #available(iOS 14.0, *) {
            return self.locationManager?.accuracyAuthorization == .reducedAccuracy
        } else {
            return false
        }
    }

    // MARK: - CLLocationManagerDelegate Method

    func requestLocation() {
        //Logger.output(message: "Stop Location Updates")
        self.locationManager?.requestLocation()
    }

    /// Start updating location data
    func startUpdatingLocation() {
        //Logger.output(message: "Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }

    /// Stop updating location data
    func stopUpdatingLocation() {
        //Logger.output(message: "Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }

    /// Call when iOS device failed to get location data.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.updateLocationDidFailWithError(error: error)
    }

    /// Call when iOS device succeeded to get location data.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            self.stopUpdatingLocation()
            return
        }
        self.currentLocation = location
        self.updateLocation(currentLocation: location)
        self.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        let authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .notDetermined:
            self.locationManager?.requestAlwaysAuthorization()
        case .authorizedAlways:
            self.startUpdatingLocation()
        case .restricted, .denied, .authorizedWhenInUse:
            break
        @unknown default:
            fatalError()
        }

        let accuracyAuthorization = manager.accuracyAuthorization
        switch accuracyAuthorization {
        case .fullAccuracy:
            break
        case .reducedAccuracy:
            break
        default:
            break
        }
    }
}
