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
    
    var body: some View {
        HStack {
            Text(account.username)
            if account.isBusy {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
            }
        }
    }
}
