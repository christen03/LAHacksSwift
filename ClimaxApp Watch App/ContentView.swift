//
//  ContentView.swift
//  ClimaxApp Watch App
//
//  Created by Christen Xie on 4/20/24.
//

import SwiftUI
import WatchConnectivity
import HealthKit

struct ContentView: View {
    @StateObject private var connector = iOSConnect()
    private let healthStore = HKHealthStore()
    private let healthKitManager = HealthKitManager()
    private let mockHeartRateManager = MockHeartRateManager()
    
    var body: some View {
        VStack {
            if let roomName = connector.roomName {
                    Text("Currently in room: \(roomName)")
            } else{
                Text("Not in a room!")
                
            }
            Button(action: {
                //startSendingHeartRate()
                startSendingMockHeartRate()
            }) {
                Text("Send Live Heart Rate")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .disabled(connector.roomName == nil)
            }
        }
        .padding()
        .onAppear {
            requestHealthAuthorization()
        }
    }
    
    
    private func requestHealthAuthorization() {
        healthKitManager.requestHealthAuthorization { success, error in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
            } else {
                print("HealthKit authorization request was successful")
            }
        }
    }
    
    private func startSendingHeartRate() {
        healthKitManager.startObservingHeartRate { heartRate in
            connector.sendDataToiOS(heartRate: heartRate)
        }
    }
    
    private func startSendingMockHeartRate() {
        mockHeartRateManager.startGeneratingMockHeartRate { heartRate in
            connector.sendDataToiOS(heartRate: heartRate)
        }
        
    }
}
//
#Preview {
    ContentView()
}
