//
//  AccountView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(Account.self)
    var account
        
    var body: some View {
        Form {
            LabeledContent("username", value: account.username)
            LabeledContent("id",       value: account.id)
            LabeledContent("order",    value: account.orderIndex.debugDescription)
            LabeledContent("delete",   value: account.deleteMark.description)
            LabeledContent("session",  value: account.session.debugDescription)
        }
    }
}

