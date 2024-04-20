//
//  FirebaseHeartRateManager.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//

import Foundation
import FirebaseFirestore

final class FirebaseHeartRateManager{
    let userViewModel: UserViewModel
    let db = Firestore.firestore()
    
    init(userViewModel: UserViewModel){
        self.userViewModel=userViewModel
    }
    
    func writeHeartRateToFirestore(heartRate: Int) async {
        guard let userID = userViewModel.user?.userID,
        let roomID = userViewModel.room?.roomID else{
            return
        }
        
        let heartRateDocRef = db.collection("accounts").document(userID).collection("heartRates").document(roomID)
        
        do {
            let document = try await heartRateDocRef.getDocument()
            if let data = document.data() {
                var heartRateArray = data["heartRate"] as? [Int] ?? []
                heartRateArray.append(heartRate)
                try await heartRateDocRef.updateData(["heartRate": heartRateArray])
                print("Heart rate array successfully updated in Firestore")
            } else {
                let heartRateData: [String: Any] = ["heartRate": [heartRate]]
                try await heartRateDocRef.setData(heartRateData)
                print("Heart rate document successfully created in Firestore")
            }
        } catch {
            print("Error writing heart rate to Firestore: \(error.localizedDescription)")
        }
    }
}
