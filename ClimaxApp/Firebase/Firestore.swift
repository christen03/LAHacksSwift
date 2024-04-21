//
//  Firestore.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//

import Foundation
import FirebaseFirestore


final class FirebaseLoginData {
    let db = Firestore.firestore()
    
    func findUserFromCode(code: String) async -> UserModel? {
        do {
            let numberCode = Int(code)!
            let querySnapshot = try await db.collection("accounts")
                .whereField("code", isEqualTo: numberCode)
                .getDocuments()
            
            if let userDocument = querySnapshot.documents.first {
                let userID = userDocument.documentID
                let data = userDocument.data()
                let name = data["name"] as? String
                let photoURL = data["photoURL"] as? String
                return UserModel(userID: userID, name: name ?? "", profileImageURL: photoURL != nil ? URL(string: photoURL!) : nil)
            }
                else {
                return nil
            }
        } catch {
            print("Error finding user: \(error)")
            return nil
        }
    }
    
    func watchUserRoom(userID: String, completion: @escaping (String?) -> Void) {
        let userDocument = db.collection("accounts").document(userID)
        
        userDocument.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                completion(nil)
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                completion(nil)
                return
            }
            
            if let room = data["roomId"] as? String {
                completion(room)
            } else {
                completion(nil)
            }
        }
    }
    
    func getRoomForUser(roomID: String) async -> RoomModel? {
        do {
            let documentSnapshot = try await db.collection("rooms").document(roomID).getDocument()
            if let data = documentSnapshot.data(),
               let roomName = data["name"] as? String {
                let room = RoomModel(roomID: documentSnapshot.documentID, roomName: roomName)
                return room
            } else {
                return RoomModel(roomID: documentSnapshot.documentID, roomName: "Unnamed Room")
            }
        } catch {
            print("Error getting room: \(error)")
            return nil
        }
    }
}
