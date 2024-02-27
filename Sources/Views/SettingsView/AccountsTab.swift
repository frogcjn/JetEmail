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
    
    var body: some View {
        SplitView {
            AccountList()
        } detail: {
            if let item = settings.selectedAccount {
                AccountView()
                    .itemModel(item)
            } else {
                Color.clear
            }
        }
    }
}
