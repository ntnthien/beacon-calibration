//
//  ContentView.swift
//  BeaconCalibration
//
//  Created by Do Nguyen on 11/30/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var calibrationManager = BeaconCalibrationManager()
    @State private var uuid = "2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1"
    @State private var showingInstructions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // UUID Input
                VStack(alignment: .leading) {
                    Text("Beacon UUID:")
                        .font(.headline)
                    TextField("Enter UUID", text: $uuid)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                
                VStack {
                    Text("Current RSSI: \(calibrationManager.currentRSSI) dBm")
                        .font(.headline)
                    Text("Average RSSI: \(String(format: "%.1f", calibrationManager.averageRSSI)) dBm")
                        .font(.headline)
                    Text("Samples: \(calibrationManager.rssiReadings.count)/\(calibrationManager.samplesNeeded)")
                        .font(.subheadline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Status
                Text(calibrationManager.status)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Control Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        if calibrationManager.isMonitoring {
                            calibrationManager.stopCalibration()
                        } else {
                            calibrationManager.startCalibration(uuid: uuid)
                        }
                    }) {
                        Text(calibrationManager.isMonitoring ? "Stop" : "Start")
                            .foregroundColor(.white)
                            .frame(width: 100)
                            .padding()
                            .background(calibrationManager.isMonitoring ? Color.red : Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        calibrationManager.clearReadings()
                    }) {
                        Text("Clear")
                            .foregroundColor(.white)
                            .frame(width: 100)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
                
                // Instructions Button
                Button(action: {
                    showingInstructions = true
                }) {
                    Text("Show Instructions")
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Beacon Calibration")
            .sheet(isPresented: $showingInstructions) {
                InstructionsView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
