//
//  SwiftUIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Data

struct AccountSectionHeader: View {
    
    @Environment(Account.self)
    var account
    
    let action: () async -> ()
    
    @State
    var isOnHover = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "circle.fill")
                .foregroundColor(account.id.sessionState.color)
                .frame(width: 18, alignment: .center)
                .opacity(isOnHover || account.isBusy ? 0 : 1)
                .overlay {
                    if account.isBusy {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)
                    } else if isOnHover {
                        Button("update", systemImage: "arrow.clockwise") {
                            Task { await action() }
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .onHover { isOnHover = $0 }
            
            Text(account.username)
            switch account.id.platform {
            case .microsoft:
                Text("(Outlook)")
            case .google:
                Text("(Gmail)")
            }
            //Text(account.platformState.rawValue)
            //RefreshButton(isBusy: account.isBusy, action: action)
        }
    }
}
