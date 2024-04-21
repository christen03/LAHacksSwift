//
//  MockHeartRateManager.swift
//  ClimaxApp Watch App
//
//  Created by Christen Xie on 4/20/24.
//

import Foundation
import SwiftUI
class MockHeartRateManager: ObservableObject {
    private var timer: Timer?
    private var onHeartRateUpdate: ((Int) -> Void)?
    @Published var isSendingHeartRate = false
    @Published var currentHeartRate = 0
    private var scaryMomentChance: Double = 0.1
    private var scaryMomentDuration: Int = 7
    private var scaryMomentStartTime: Date?

    
    func startGeneratingMockHeartRate(onUpdate: @escaping (Int) -> Void) {
        isSendingHeartRate = true
        onHeartRateUpdate = onUpdate
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            let mockHeartRate = self?.generateRandomHeartRate() ?? 0
            onUpdate(mockHeartRate)
        }
    }
    
    func stopGeneratingMockHeartRate() {
        timer?.invalidate()
        timer = nil
        onHeartRateUpdate = nil
    }
    
    private func generateRandomHeartRate() -> Int {
            if scaryMomentStartTime == nil {
                if Double.random(in: 0...1) < scaryMomentChance {
                    scaryMomentStartTime = Date()
                }
            } else {
                let currentTime = Date()
                let elapsedTime = Int(currentTime.timeIntervalSince(scaryMomentStartTime!))
                
                if elapsedTime < scaryMomentDuration {
                    return Int.random(in: 120...130)
                } else {
                    scaryMomentStartTime = nil
                }
            }
            
            return Int.random(in: 60...80)
        }
    
}

