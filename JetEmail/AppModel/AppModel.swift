//
//  AppViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI
import SwiftData // for ModelContainer
import Combine   // for PassthroughSubject
import os        // for Logger

@dynamicMemberLookup
@Observable
final class AppModel {
    
    var logger = Logger(subsystem: "me.frogcjn.jet-email", category: "AppModel")
    var willRemoveAccount = PassthroughSubject<Account, Never>()
    
    
    @MainActor /* for isBusy */
    var isBusy = false
    
    // settings
    let settings = SettingsModel()

    // model container
    let modelContainer = try! ModelContainer(for: Account.self, MailFolder.self, Message.self)
    
    // google client
    let googleClient = Google.Client()
    
    // microsoft client
    // avoid "UI unresponsiveness" warning on MSALPublicClientApplication init
    @BackgroundActor
    var _microsoftClient: Microsoft.Client?
    
    @BackgroundActor
    var microsoftClient: Microsoft.Client {
        get throws {
            BackgroundActor.assertIsolated()
            if let _microsoftClient { return _microsoftClient }
            let client = try Microsoft.Client()
            _microsoftClient = client
            return client
        }
    }
}


// @dynamicMemberLookup
extension AppModel {
    // Model
    subscript<Value>(dynamicMember keyPath: KeyPath<ModelContainer, Value>) -> Value {
        modelContainer[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<ModelContainer, Value>) -> Value {
        _read { yield modelContainer[keyPath: keyPath] }
        _modify { var modelContainer = modelContainer; yield &modelContainer[keyPath: keyPath] }
    }
}

