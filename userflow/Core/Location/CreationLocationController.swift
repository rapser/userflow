//
//  CreationLocationController.swift
//  userflow
//

import Combine
import CoreLocation
import Foundation

/// **`MT-12`**: **When In Use** + una captura **`requestLocation()`** tras pulsar botón en **alta**.
final class CreationLocationController: NSObject, ObservableObject {
    struct CoordinatesCapture: Identifiable {
        let id: UUID = UUID()
        let latitudeDisplay: String
        let longitudeDisplay: String

        init(latitude: Double, longitude: Double) {
            latitudeDisplay = String(format: "%.6f°", latitude)
            longitudeDisplay = String(format: "%.6f°", longitude)
        }
    }

    @Published var sheetPayload: CoordinatesCapture?
    /// Inline banner (denied network fix failure, …).
    @Published private(set) var bannerMessage: String?
    @Published private(set) var isLocating: Bool = false

    private var pendingFixAfterUpgrade = false

    private let manager: CLLocationManager

    override init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func userRequestedCoordinates() {
        bannerMessage = nil
        sheetPayload = nil

        switch manager.authorizationStatus {
        case .notDetermined:
            pendingFixAfterUpgrade = true
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            startSingleFixIfPossible()
        case .denied, .restricted:
            bannerMessage = String(localized: String.LocalizationValue("users.create.locationDenied"))
            pendingFixAfterUpgrade = false
        @unknown default:
            bannerMessage = String(localized: String.LocalizationValue("users.create.locationDenied"))
            pendingFixAfterUpgrade = false
        }
    }

    func dismissSheet() {
        sheetPayload = nil
    }

    func clearBanner() {
        bannerMessage = nil
    }

    private func startSingleFixIfPossible() {
        guard manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways else { return }

        isLocating = true
        manager.requestLocation()
    }
}

extension CreationLocationController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                if pendingFixAfterUpgrade {
                    pendingFixAfterUpgrade = false
                    startSingleFixIfPossible()
                }
            case .denied, .restricted:
                pendingFixAfterUpgrade = false
                bannerMessage = String(localized: String.LocalizationValue("users.create.locationDenied"))
                isLocating = false
            case .notDetermined:
                break
            @unknown default:
                pendingFixAfterUpgrade = false
                isLocating = false
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLocating = false
            guard let coordinate = locations.last?.coordinate else {
                bannerMessage = String(localized: String.LocalizationValue("users.create.locationUnavailable"))
                return
            }
            sheetPayload = CoordinatesCapture(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLocating = false
            if let cle = error as? CLError, cle.code == .denied {
                bannerMessage = String(localized: String.LocalizationValue("users.create.locationDenied"))
            } else {
                bannerMessage = String(localized: String.LocalizationValue("users.create.locationFailedGeneric"))
            }
        }
    }
}
