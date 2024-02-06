//
//  JetEmailApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/29/24.
//

import SwiftUI

@main
struct JetEmailApp: App {
    
    private var appSettings : AppSettings = .shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appSettings)
        }
        .defaultSize(width: 800, height: 600)
        #if os(macOS)
        Settings {
            AppSettingsView()
                .frame(width: 400, height: 300)
                .environment(appSettings)
        }
        #endif
    }
}
