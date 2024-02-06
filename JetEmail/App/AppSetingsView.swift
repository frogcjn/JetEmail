//
//  AppSettingsView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct AppSettingsView : View {
    
    @Environment(AppSettings.self)
    var appSettings
    
    @Environment(\.colorScheme)
    var colorScheme
    
    var body: some View {
        VStack {
            switch appSettings.appContextResult {
            case .success(let msalApp):
                LoginView(msalApp: msalApp)
            case .failure(let error):
                ErrorText("Unable to create Application Context \(String(describing: error))")
            }
            
            if colorScheme == .dark {
                Form {
                    Toggle("Show with Dark Background", isOn: Bindable(appSettings).isOnColorScheme)
                }
            }
        }
        .textSelection(.enabled)
    }
}
