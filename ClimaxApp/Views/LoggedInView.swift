//
//  LoggedInView.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//

import SwiftUI

struct LoggedInView: View {
    let user: UserModel
    let watchConnector = WatchConnect()
    
    var body: some View {
            
            VStack {
                Text("Welcome, \(user.name)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                if let photoURL = user.profileImageURL {
                    AsyncImage(url: photoURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                            )
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                    .padding()
                }
                
                Text(watchConnector.isConnected ? "Watch Connected" : "Connect Watch")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(watchConnector.isConnected ? Color.green : Color.blue)
                                    .cornerRadius(10)
                .padding()
       if let heartRate = watchConnector.currentHeartRate {
    HStack {
        Image(systemName: "heart.fill")
            .foregroundColor(.red)
            .scaleEffect(watchConnector.isConnected ? 1.2 : 1.0)
            .animation(
                .easeInOut(duration: 60.0 / Double(heartRate) / 2)
                .repeatForever(autoreverses: true),
                value: watchConnector.currentHeartRate
            )
        Text("\(heartRate) BPM")
            .foregroundColor(.white)
            .font(.headline)
    }
    .padding()
}
                
                Spacer()
            }
            .padding()
        }
    
}
