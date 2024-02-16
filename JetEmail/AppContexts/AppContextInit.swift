//
//  File.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import SwiftData // for ModelContainer

@Observable
class AppContextInit {
    
    var result: Result<AppContext, Error>?
    
    init() { 
        Task {
            result = await Task {
                
                // avoid "UI unresponsiveness" warning on MSALPublicClientApplication init
                let graphContext = try await Task.detached { try MSGraph.Client() }.value
                
                let modelContainer = try ModelContainer(for: Account.self, MailFolder.self, Message.self)

                return AppContext(
                    graphContext: graphContext,
                    modelContainer: modelContainer
                )
            }.result
        }
    }
}
