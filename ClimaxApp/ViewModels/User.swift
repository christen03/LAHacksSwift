//
//  User.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//


import Foundation

struct RoomModel{
    let roomID: String;
    let roomName: String;
}


struct UserModel {
    let userID: String;
    let name: String;
    let profileImageURL: URL?
}

class UserViewModel: ObservableObject {
    @Published var userCode = ""
    @Published var isLoading = false
    @Published var user: UserModel?
    @Published var room: RoomModel?
    
    func loginUser() {
        isLoading = true
        Task {
            let result = await FirebaseLoginData().findUserFromCode(code: userCode)
            DispatchQueue.main.async {
                self.user = result
                self.isLoading = false
            }
        }
    }
    
    func joinRoom(roomID: String, completion: @escaping (String) -> Void){
        Task {
            let room = await FirebaseLoginData().getRoomForUser(roomID: roomID)
            await MainActor.run {
                self.room = room
                if let roomName = room?.roomName {
                    completion(roomName)
                }
            }
        }
    }
}
