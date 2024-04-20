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
            if viewModel.user != nil {
                LoggedInView(userViewModel: viewModel)
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
