//
//  AccountCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct AccountCell: View {
    
    @Environment(Account.self)
    var account
    
    @State
    var username: String = ""
    
    var body: some View {
        HStack {
            Text(account.username)
                .lineLimit(1)
                .minimumScaleFactor(0)
            // Text(account.platformState.rawValue)
            
            Spacer()
            if account.isBusy {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
            } else {
                switch account.platformState {
                case .hasSession:
                    Image(systemName: "circle.fill")
                        .foregroundColor(.green)
                        .dynamicTypeSize(.xSmall)
                case .noSession:
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                        .dynamicTypeSize(.xSmall)
                }
            }
        }
    }
}
