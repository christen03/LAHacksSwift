//
//  LoggedInView.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//

import SwiftUI

struct LoggedInView: View {
    let firebaseLoginData = FirebaseLoginData()
    let userViewModel: UserViewModel
    @StateObject var watchConnector: WatchConnect
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        self._watchConnector = StateObject(wrappedValue: WatchConnect(user: userViewModel))
    }
    
    var body: some View {
        if let user=userViewModel.user{
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
                if (userViewModel.room==nil) {
                    Text("Currently not in a room")
                } else{
                    Text("In Room \(userViewModel.room?.roomName ?? "")")
                }
                
                Spacer()
                
            }
            .onAppear{
                firebaseLoginData.watchUserRoom(userID: user.userID) { room in
                    if let room = room {
                        userViewModel.joinRoom(roomID: room)
                        { roomName in
                            watchConnector.sendRoomNameToWatchOS(roomName: roomName)
                        }
                    } else {
                        print("User's room is not available")
                    }
                }
            }
            
            .padding()
        }
        else{
            Text("No user found!")
        }
    }
}
