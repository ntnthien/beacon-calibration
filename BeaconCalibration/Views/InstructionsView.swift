//
//  InstructionsView.swift
//  BeaconCalibration
//
//  Created by Do Nguyen on 11/30/24.
//
import SwiftUI

struct InstructionsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Calibration Instructions")
                        .font(.title)
                        .padding(.bottom)
                    
                    Text("1. Place the iBeacon on a non-metallic surface")
                    Text("2. Measure exactly 1 meter from the iBeacon")
                    Text("3. Hold your iPhone at the 1-meter mark")
                    Text("4. Keep the iPhone at the same height as the iBeacon")
                    Text("5. Press Start to begin calibration")
                    Text("6. Hold steady until all samples are collected")
                    Text("7. Use the resulting measured power value in your iBeacon configuration")
                    
                    Text("\nImportant Notes:")
                        .font(.headline)
                        .padding(.top)
                    Text("• Avoid metal surfaces and obstacles")
                    Text("• Keep the iPhone and iBeacon in the same orientation")
                    Text("• Take multiple measurements for best results")
                    Text("• Calibrate in the same environment where the iBeacon will be used")
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Done") {
            })
        }
    }
}
