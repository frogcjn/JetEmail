//
//  JetEmailApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/29/24.
//

import SwiftUI

@main
struct JetEmailApp: App {
    
    // state here associate with application for all windows
    private var settings = SettingsModel()
    private var appContextInit = AppContextInit()
    
    var body: some Scene {
        Group {
            /// Settings
            #if os(macOS)
            Settings {
                SettingsView()
                    .appContext(init: appContextInit)
                    .frame(width: 600, height: 300)
            }
            .defaultSize(width: 600, height: 300)
            #endif
            
            /// Mail Windows
            WindowGroup {
                MailWindow()
                    .environment(MailWindowModel())
                    .appContext(init: appContextInit)
            }
            .defaultSize(width: 800, height: 600)
        }
        .environment(settings)
    }
}
