//
//  SwiftUIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct AccountSectionHeader: View {
    
    @Environment(Account.self)
    var account
    
    let action: () async -> ()
    
    @State
    var isOnHover = false
    
    var body: some View {
        HStack(spacing: 4) {
            ZStack(alignment: .center) {
                if account.isBusy {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                } else if isOnHover {
                    Button("update", systemImage: "arrow.clockwise") {
                        Task { await action() }
                    }
                    .buttonStyle(.borderless)
                } else {
                    switch account.platformState {
                    case .hasSession:
                        Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                            //.dynamicTypeSize(.xSmall)
                    case .noSession:
                        Image(systemName: "circle.fill")
                            .foregroundColor(.red)
                            //.dynamicTypeSize(.xSmall)
                    }
                    
                }
            }.onHover {
                isOnHover = $0
            }
            .frame(width: 18, alignment: .center)
            
            Text(account.username)
            switch account.modelID.platform {
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
