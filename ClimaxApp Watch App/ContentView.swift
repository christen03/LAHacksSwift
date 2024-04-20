//
//  ContentView.swift
//  ClimaxApp Watch App
//
//  Created by Christen Xie on 4/20/24.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject private var connector = iOSConnect()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button(action: {
                connector.sendDataToiOS(heartRate: 120)
            }) {
                Text("Send Dummy Heart Rate")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
