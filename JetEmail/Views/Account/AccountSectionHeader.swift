//
//  SwiftUIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct AccountSectionHeader: View {
    
    @Environment(AppContext.Item<Account>.self)
    var context
    
    @Environment(Account.self)
    var account

    let action: () async -> ()
    
    var body: some View {
        HStack(spacing: 4) {
            Text(account.username)
            RefreshButton(isBusy: account.isBusy, action: action)
        }
    }
}
