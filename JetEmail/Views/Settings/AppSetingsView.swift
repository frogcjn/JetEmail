//
//  AppSettingsView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI
import SwiftData

struct AppSettingsView : View {
    
    @Bindable
    var viewModel: AppViewModel
    
    @Environment(\.colorScheme)
    var colorScheme
    
    var body: some View {
        VStack {
            AccountsView(viewModel: viewModel)
            
            if colorScheme == .dark {
                Form {
                    Toggle("Show with Dark Background", isOn: $viewModel.isShowingWithDarkBackground)
                }
            }
        }
        .textSelection(.enabled)
    }
}
