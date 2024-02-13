//
//  LoginView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI
import SwiftData
import MSAL

struct AccountsView : View {
    
    @Bindable
    var viewModel: AppViewModel
    
    @Query
    var accounts: [Account]
    
    @State
    var selectedAccount: Account?
    
    var body: some View {
        NavigationSplitView {
            List(accounts, selection: $selectedAccount) { item in
                Text(item.username)
                    .tag(item)
            }
            .toolbar(removing: .sidebarToggle)
            .toolbar {
                Button("Add", systemImage: "plus") {
                    Task { try await viewModel.addAccount() } // TODO: catch error
                }
                
                Button("Remove", systemImage: "minus") {
                    guard let account = selectedAccount else { return }
                    Task { try await viewModel.removeAccount(account) } // TODO: catch error
                }.disabled(selectedAccount == nil)
            }
        } detail: {
            if let account = selectedAccount {
                LabeledContent("username") {
                    Text(account.username)
                }
                LabeledContent("id") {
                    Text(account.id)
                }
            }
            
        }
            /*if let account = msalApp.account?.account {
                HStack {
                    Text(account.username ?? "")
                        .textSelection(.enabled)
                    Spacer()

                    /*Button("Refresh") {
                        Task { await msalApp.refresh() }
                    }*/
                    
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
            }*/
        // }.padding()
    }

}
