//
//  AccountCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Data

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
            
            Image(systemName: "circle.fill")
                .foregroundColor(account.sessionState.color)
                .dynamicTypeSize(.xSmall)
                .opacity(account.isBusy ? 0 : 1)
                .overlay {
                    if account.isBusy {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)
                    }
                }
        }
    }
}
