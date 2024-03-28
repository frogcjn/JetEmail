//
//  AccountView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmailData // for account

struct AccountView: View {
    @Environment(Account.self)
    var account
        
    var body: some View {
        Form {
            #if DEBUG
            LabeledContent("_id"     , value: account.uniqueID)
            #endif
            LabeledContent("username", value: account.username)
            LabeledContent("order"   , value: account.orderIndex.debugDescription)
            LabeledContent("delete"  , value: account.deleteMark.description)
            LabeledContent("session" , value: account.cachedSession.debugDescription)
        }
    }
}
