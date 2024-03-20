//
//  LoginView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI

struct AccountsTab : View {
    
    @Environment(SettingsModel.self)
    var settings
    
    @Environment(AppModel.self)
    var appModel
    
    var body: some View {
        SplitView {
            AccountList()
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } detail: {
            if let account = settings.selectedAccount {
                AccountView()
                    .environment(account)
            } else {
                VStack {
                    Button {
                        Task { await appModel.signIn(platform: .microsoft) }
                    } label: {
                        Label("Microsoft Outlook", image: "Outlook")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        Task { await appModel.signIn(platform: .google) }
                    } label: {
                        Label("Google Gmail", image: "Gmail")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
                .labelStyle(.titleAndIcon)
                .disabled(appModel.isBusy)
            }
        }
    }
}
