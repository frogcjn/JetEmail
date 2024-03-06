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
    private let appModel = AppModel.shared
    
    var body: some Scene {
        Group {
            /// Settings
            #if os(macOS)
            Settings {
                SettingsView()
                    .frame(width: 720, height: 300)
            }
            .defaultSize(width: 720, height: 300)
            #endif
            

            
            /// Mail Windows
            WindowGroup {
                MailWindow()
#if TARGET_OS_IPHONE
Text("Target_OS_IPHONE")
#endif
            }
            .defaultSize(width: 800, height: 600)
        }
        .appModel(appModel)
    }
}
