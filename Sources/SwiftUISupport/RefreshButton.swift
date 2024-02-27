//
//  BusyView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct RefreshButton : View {
    let isBusy: Bool
    let action: () async -> Void
    
    var body: some View {
        if isBusy {
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.small)
        } else {
            Button("update", systemImage: "arrow.clockwise") {
                Task { await action() }
            }
            .buttonStyle(.borderless)
        }
    }
}
