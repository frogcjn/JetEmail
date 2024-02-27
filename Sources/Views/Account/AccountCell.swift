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
            Text(account.platformState.rawValue)
            if account.isBusy {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
            }
        }
    }
}
