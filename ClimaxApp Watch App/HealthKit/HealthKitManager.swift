//
//  HealthKit.swift
//  ClimaxApp Watch App
//
//  Created by Christen Xie on 4/20/24.


import Foundation
import HealthKit

class HealthKitManager: NSObject{
        private let healthStore = HKHealthStore()
        private var heartRateObserverQuery: HKObserverQuery?
        private var onHeartRateUpdate: ((Int) -> Void)?

        func requestHealthAuthorization(completion: @escaping (Bool, Error?) -> Void) {
            guard HKHealthStore.isHealthDataAvailable() else {
                completion(false, nil)
                return
            }

            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            healthStore.requestAuthorization(toShare: [heartRateType], read: [heartRateType]) { success, error in
                completion(success, error)
            }
        }

        func startObservingHeartRate(onUpdate: @escaping (Int) -> Void) {
            onHeartRateUpdate = onUpdate

            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [weak self] query, completionHandler, error in
                if let error = error {
                    print("Error observing heart rate: \(error.localizedDescription)")
                    return
                }

                self?.fetchLatestHeartRate { heartRate in
                    if let heartRate = heartRate {
                        onUpdate(heartRate)
                    }
                    completionHandler()
                }
            }

            heartRateObserverQuery = query
            healthStore.execute(query)
        }

        func stopObservingHeartRate() {
            if let query = heartRateObserverQuery {
                healthStore.stop(query)
                heartRateObserverQuery = nil
            }
            onHeartRateUpdate = nil
        }

        private func fetchLatestHeartRate(completion: @escaping (Int?) -> Void) {
            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                guard let samples = samples as? [HKQuantitySample], let heartRateSample = samples.first else {
                    completion(nil)
                    return
                }

                let heartRateUnit = HKUnit(from: "count/min")
                let heartRate = Int(heartRateSample.quantity.doubleValue(for: heartRateUnit))
                print("Heart Rate: \(heartRate)")
                completion(heartRate)
            }

            healthStore.execute(query)
        }
    }
