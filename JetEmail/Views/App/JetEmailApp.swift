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
    private var result: Result<AppViewModel, Error>
    
    init() {
        result = Result {
            AppViewModel(
                appSettings: AppSettings(),
                modelContext: try ModelContainer(for: Account.self, MailFolder.self, Message.self).mainContext,
                msalContext: try MSALContext()
            )
        }
    }

    var body: some Scene {
        Group {
            WindowGroup {
                ResultView(result) { viewModel in
                    ContentView(viewModel: WindowViewModel(viewModel))
                        .modelContainer(viewModel.container)
                        .task {
                            try! viewModel.syncAccountsFromMSAL() // TODO: Catch Error
                        }
                }
            }
            .defaultSize(width: 800, height: 600)
            
            // Settings
            #if os(macOS)
            Settings {
                ResultView(result) { viewModel in
                    AppSettingsView(viewModel: viewModel)
                        .modelContainer(viewModel.container)
                }
   
            }
            .defaultSize(width: 400, height: 300)
            #endif
        }
    }
}


