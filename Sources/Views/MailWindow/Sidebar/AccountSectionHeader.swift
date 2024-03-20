//
//  SwiftUIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmailData // for Account

struct AccountSectionHeader: View {
    
    @Environment(Account.self)
    var account
    
    let action: () async -> ()
    
    @State
    var isOnHover = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "circle.fill")
                .foregroundColor(account.sessionState.color)
                .frame(width: 18, alignment: .center)
                .opacity(isOnHover || account.isBusy ? 0 : 1)
                .overlay {
                    if account.isBusy {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)
                    } else if isOnHover {
                        Button("update", systemImage: "arrow.clockwise") {
                            Task { await action() }
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .onHover { isOnHover = $0 }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(account.username)
                    .lineLimit(2)

                switch account.resourceID.platform {
                case .microsoft:           platformLabel(LocalizedStringKey("Microsoft Outlook"))
                case .google:              platformLabel(LocalizedStringKey("Google Gmail"))
                case .other(let rawValue): platformLabel(LocalizedStringKey("Unknown \(rawValue)"))
                }
            }
            //Text(account.platformState.rawValue)
            //RefreshButton(isBusy: account.isBusy, action: action)
        }
    }

    @ViewBuilder
    private func platformLabel(_ description: LocalizedStringKey) -> some View {
        Text(description)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .lineLimit(2)
    }
}
