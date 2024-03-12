//
//  LoginView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI
import AuthenticationServices

struct AccountsTab : View {
    
    @Environment(SettingsModel.self)
    var settings
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(\.webAuthenticationSession)
    var webAuthenticationSession
    
    var body: some View {
        SplitView {
            AccountList()
        } detail: {
            if let item = settings.selectedAccount {
                AccountView()
                    .itemModel(item)
            } else {
                VStack {
                    Button {
                        Task { await appModel.signIn(platform: .microsoft, webAuthenticationSession: webAuthenticationSession) }
                    } label: {
                        Label("Microsoft Outlook", image: "Outlook")
                    }//.disabled(context.isBusy)
                    
                    Button {
                        Task { await appModel.signIn(platform: .google, webAuthenticationSession: webAuthenticationSession) }
                    } label: {
                        Label("Google Gmail", image: "Gmail")
                    }
                    //.disabled(context.isBusy)
                }
                .labelStyle(.titleAndIcon)
            }
        }
    }
}
