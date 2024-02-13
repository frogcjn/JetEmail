//
//  ContentView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/29/24.
//

import SwiftUI
import SwiftData
import MSAL


struct ContentView: View {

    // state here associate with application for all windows
    @Bindable
    var viewModel: WindowViewModel
    
    @Query
    var accounts: [Account]
    
    var body: some View {
        Group {
            if !accounts.isEmpty {
                MailFolderSplitView(viewModel: viewModel)
            } else {
                SettingsLink {
                    Text("Open Settings to login in…")
                }
            }
        }
    }
}

/*
#Preview {
    ContentView()
}

*/
