//
//  MockHeartRateManager.swift
//  ClimaxApp Watch App
//
//  Created by Christen Xie on 4/20/24.
//

import Foundation

class MockHeartRateManager {
    private var timer: Timer?
    private var onHeartRateUpdate: ((Int) -> Void)?
    
    func startGeneratingMockHeartRate(onUpdate: @escaping (Int) -> Void) {
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
        return Int.random(in: 60...100)
    }
}
