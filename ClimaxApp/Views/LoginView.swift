//
//  LoginView.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Welcome to Climax")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            TextField("Enter user code", text: $viewModel.userCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding()
            
            Button(action: {
                viewModel.loginUser()
            }) {
                Text("Enter User Code")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
