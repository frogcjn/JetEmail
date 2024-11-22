//
//  JetEmailApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/29/24.
//

import SwiftUI
import JetEmailPlatform

@main
struct JetEmailApp: App {
    var body: some Scene {
        Group {
            /// Settings
            #if os(macOS)
            Settings {
                SettingsView()
                    .frame(width: 720, height: 300)
            }
            .defaultSize(width: 720, height: 300)
            #else
            /*WindowGroup {
                SettingsView()
                    .frame(width: 720, height: 300)
            }
            .defaultSize(width: 720, height: 300)*/
            #endif
            
            /// Mail Windows
            WindowGroup {
                MailWindow()
            }
            #if !os(visionOS)
            .defaultSize(width: 800, height: 600)
            #endif
        }
        .environment(SettingsModel.shared)
        .environment(AppModel.shared)
        .modelContainer(.shared)
    }
}
