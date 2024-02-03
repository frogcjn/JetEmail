//
//  ContentView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/29/24.
//

import SwiftUI

import MSAL


struct ContentView: View {

    @Environment(AppSettings.self)
    var appSettings
    
    var body: some View {
        if let userContext = appSettings.userContext {
            MailFolderSplitView(model:  WindowViewModel(userContext))
                .environment(userContext)
        } else {
            SettingsLink(label: {
                Text("Open Settings to login in…")
            })
        }
    }
}

#Preview {
    ContentView()
}

