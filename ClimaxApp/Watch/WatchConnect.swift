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
    let userViewModel: UserViewModel
    let firebaseHeartRateManager: FirebaseHeartRateManager
    @Published var isConnected = false
    @Published var currentHeartRate: Int? = nil
    
    init(session: WCSession = WCSession.default, user: UserViewModel) {
        self.userViewModel=user
        self.session = session
        self.firebaseHeartRateManager = FirebaseHeartRateManager(userViewModel: user)
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
        
        if let heartRate = message["heartRate"] as? Int {
            Task{
                await MainActor.run{
                    self.currentHeartRate = heartRate
                }
                await self.firebaseHeartRateManager.writeHeartRateToFirestore(heartRate: heartRate)
            }
        }
    }
    
    func sendRoomNameToWatchOS(roomName: String) {
        let message = ["roomName": roomName]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
        print("Sent message to iOS")
    }
    
}
