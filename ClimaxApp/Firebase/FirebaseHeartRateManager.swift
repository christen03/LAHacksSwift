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
    
    func writeHeartRateToFirestore(heartRate: Int, completion: @escaping (Error?) -> Void) {
        guard let userID = userViewModel.user?.userID,
              let roomID = userViewModel.room?.roomID else {
            completion(nil)
            return
        }
        
        let heartRateDocRef = db.collection("accounts").document(userID).collection("heartRates").document(roomID)
        let roomDocRef = db.collection("rooms").document(roomID)
        
        roomDocRef.addSnapshotListener { [weak self] snapshot, error in
            guard self != nil else { return }
            
            if let error = error {
                print("Error listening to room document: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            let isPlaying = snapshot.data()?["isPlaying"] as? Bool ?? false
            print("isPlaying: \(isPlaying)")
            
            if isPlaying {
                heartRateDocRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error getting heart rate document from Firestore: \(error.localizedDescription)")
                        completion(error)
                        return
                    }
                    
                    if let data = document?.data() {
                        var heartRateArray = data["heartRate"] as? [Int] ?? []
                        heartRateArray.append(heartRate)
                        
                        heartRateDocRef.updateData(["heartRate": heartRateArray]) { error in
                            if let error = error {
                                print("Error updating heart rate array in Firestore: \(error.localizedDescription)")
                                completion(error)
                            } else {
                                print("Heart rate array successfully updated in Firestore")
                                completion(nil)
                            }
                        }
                    } else {
                        let heartRateData: [String: Any] = ["heartRate": [heartRate]]
                        
                        heartRateDocRef.setData(heartRateData) { error in
                            if let error = error {
                                print("Error creating heart rate document in Firestore: \(error.localizedDescription)")
                                completion(error)
                            } else {
                                print("Heart rate document successfully created in Firestore")
                                completion(nil)
                            }
                        }
                    }
                }
            } else {
                completion(nil)
            }
        }
    }}
