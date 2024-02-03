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
    
    var body: some View {
        Group {
            switch appSettings.appContextResult {
            case .success(let msalApp):
                LoginView(msalApp: msalApp)
            case .failure(let error):
                ErrorText("Unable to create Application Context \(String(describing: error))")
            }
        }
        .textSelection(.enabled)
    }
}
