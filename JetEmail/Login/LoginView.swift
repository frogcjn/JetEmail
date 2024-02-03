//
//  LoginView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI

struct LoginView : View {
    
    @Bindable
    var msalApp: AppContext
    
    var body: some View {
        VStack {
            if let account = msalApp.user?.account {
                HStack {
                    Text(account.username ?? "")
                        .textSelection(.enabled)
                    Spacer()
                    Button("Sign out") {
                        Task { await msalApp.signOut() }
                    }
                }
            } else {
                Button("Sign in") {
                    Task { await msalApp.signIn(allowInteractive: true) }
                }
            }
            ScrollView {
                Text(msalApp.loginHint)
                    .textSelection(.enabled)
            }
        }.padding()
    }
}
