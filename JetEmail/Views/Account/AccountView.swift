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
            LabeledContent("username") {
                Text(account.username)
            }
            LabeledContent("id") {
                Text("\(try! account.modelID.jsonString)")
            }
        }
    }
}

