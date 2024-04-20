//
//  WatchConnect.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//

import Foundation
import WatchConnectivity
class WatchConnect: NSObject, ObservableObject, WCSessionDelegate {
    var session: WCSession
    @Published var isConnected = false
    @Published var currentHeartRate: Int? = nil

    init(session: WCSession = WCSession.default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = session.isReachable
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = session.isReachable
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }

    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Received message: \(message)")
        DispatchQueue.main.async {
            if let heartRate = message["heartRate"] as? Int {
                self.currentHeartRate = heartRate
            }
            if let heartRate = message["heartRate"] as? String{
                self.currentHeartRate = Int(heartRate) ?? 115
            }
        }
    }
}
