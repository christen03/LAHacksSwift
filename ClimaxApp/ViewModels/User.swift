//
//  User.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//


import Foundation


struct UserModel {
    let userID: String;
    let name: String;
    let profileImageURL: URL?
}

class UserViewModel: ObservableObject {
    @Published var userCode = ""
    @Published var isLoading = false
    @Published var user: UserModel?
    
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
}
