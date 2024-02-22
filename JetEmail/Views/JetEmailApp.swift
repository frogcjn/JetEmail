//
//  JetEmailApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/29/24.
//

import SwiftUI
import SwiftData

@main
struct JetEmailApp: App {
    
    // state here associate with application for all windows
    private let appModel = AppModel()
    var body: some Scene {
        Group {
            /// Settings
            #if os(macOS)
            Settings {
                SettingsView()
                    .frame(width: 600, height: 300)
            }
            .defaultSize(width: 600, height: 300)
            #endif
            
            /// Mail Windows
            WindowGroup {
                MailWindow()
            }
            .defaultSize(width: 800, height: 600)
        }
        .appModel(appModel)
    }
}
