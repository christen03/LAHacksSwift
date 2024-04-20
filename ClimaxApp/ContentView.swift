//
//  ContentView.swift
//  ClimaxApp
//
//  Created by Christen Xie on 4/20/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            if let user = viewModel.user {
                LoggedInView(user: user)
            } else {
                // Show the login view
                LoginView(viewModel: viewModel)
            }
        }
        .padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
