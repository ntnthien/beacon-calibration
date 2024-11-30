//
//  BeaconCalibrationManager.swift
//  BeaconCalibration
//
//  Created by Do Nguyen on 11/30/24.
//

import CoreLocation
import Combine

class BeaconCalibrationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private var beaconConstraint: CLBeaconIdentityConstraint?
    private var beaconRegion: CLBeaconRegion?
    
    @Published var isMonitoring = false
    @Published var rssiReadings: [Int] = []
    @Published var currentRSSI: Int = 0
    @Published var averageRSSI: Double = 0
    @Published var status = "Not started"
    
    let samplesNeeded = 20
    let measurementDistance = 1.0 
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startCalibration(uuid: String) {
        guard let uuid = UUID(uuidString: uuid) else {
            status = "Invalid UUID format"
            return
        }
        
        rssiReadings.removeAll()
        
        beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid)
        beaconRegion = CLBeaconRegion(
            beaconIdentityConstraint: beaconConstraint!,
            identifier: "CalibrationBeacon"
        )
        
        if let region = beaconRegion {
            locationManager.startMonitoring(for: region)
            locationManager.startRangingBeacons(satisfying: beaconConstraint!)
            isMonitoring = true
            status = "Starting calibration..."
        }
    }
    
    func stopCalibration() {
        if let region = beaconRegion {
            locationManager.stopMonitoring(for: region)
            locationManager.stopRangingBeacons(satisfying: beaconConstraint!)
            isMonitoring = false
            status = "Calibration stopped"
        }
    }
    
    private func processNewReading(_ rssi: Int) {
        rssiReadings.append(rssi)
        currentRSSI = rssi
        
        averageRSSI = Double(rssiReadings.reduce(0, +)) / Double(rssiReadings.count)
        
        if rssiReadings.count >= samplesNeeded {
            let measuredPower = Int(round(averageRSSI))
            status = "Calibration complete!\nRecommended measured power: \(measuredPower)"
            stopCalibration()
        } else {
            status = "Taking measurements... (\(rssiReadings.count)/\(samplesNeeded))"
        }
    }
    
    func clearReadings() {
        rssiReadings.removeAll()
        currentRSSI = 0
        averageRSSI = 0
        status = "Readings cleared"
    }
}

extension BeaconCalibrationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        guard let beacon = beacons.first, beacon.rssi != 0 else { return }
        processNewReading(beacon.rssi)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        status = "Ranging failed: \(error.localizedDescription)"
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        status = "Monitoring failed: \(error.localizedDescription)"
    }
}
