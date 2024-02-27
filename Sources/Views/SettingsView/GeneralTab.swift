//
//  GeneralSettingsView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct GeneralTab: View {
    
    @Environment(SettingsModel.self)
    var settings
    
    @Environment(\.colorScheme)
    var colorScheme
    
    var body: some View {
        Form {
            // Feature: Message - Dark Background
            if colorScheme == .dark {
                Toggle("Show with Dark Background", isOn: Bindable(settings).isShowingWithDarkBackground)
            }
        }
    }
}

/*
#Preview {
    GeneralSettingsView()
}
*/
