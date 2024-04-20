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
}
