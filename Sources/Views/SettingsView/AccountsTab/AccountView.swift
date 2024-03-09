//
//  AccountView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Data

struct AccountView: View {
    
    @Environment(Account.self)
    var account
        
    var body: some View {
        Form {
            LabeledContent("_id"     , value: account.rawID)
            LabeledContent("username", value: account.username)
            LabeledContent("order"   , value: account.orderIndex.debugDescription)
            LabeledContent("delete"  , value: account.deleteMark.description)
            LabeledContent("session" , value: account.id.storedSession.debugDescription)
        }
    }
}

