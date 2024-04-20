//
//  iOSConnect.swift
//  ClimaxApp Watch App
//
//  Created by Christen Xie on 4/20/24.
//

import Foundation
import WatchConnectivity


class iOSConnect: NSObject, ObservableObject, WCSessionDelegate {
    
    var session: WCSession;
    @Published var roomName: String?
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if session.isReachable {
            print("Watch session is reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        
        if let roomName = message["roomName"] as? String {
            Task{
                await MainActor.run{
                    self.roomName = roomName
                }
            }
        }
    }
    
    func sendDataToiOS(heartRate: Int) {
        let message = ["heartRate": heartRate]
        session.sendMessage(message, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
        }
        print("Sent message to iOS")
    }
}
