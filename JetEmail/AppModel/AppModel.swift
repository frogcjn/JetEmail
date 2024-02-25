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

// @dynamicMemberLookup
@Observable
final class AppModel {
    
    // settings
    let settings       = SettingsModel()
    let modelContainer = ModelContainer.shared
    let googleClient   = Google.Client.shared
    var microsoftClient: Microsoft.Client { get async throws {
        try await .shared
    }  }
    
    var isBusy = false
    let logger = Logger(subsystem: "me.frogcjn.jet-email", category: "AppModel")

    // Feature: Unselection - Will Sign Out Account
    var willSignOutAccount = PassthroughSubject<Account, Never>()
}


// @dynamicMemberLookup
extension AppModel {
    // Model
    /*subscript<Value>(dynamicMember keyPath: KeyPath<ModelContainer, Value>) -> Value {
        modelContainer[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<ModelContainer, Value>) -> Value {
        _read { yield modelContainer[keyPath: keyPath] }
        _modify { var modelContainer = modelContainer; yield &modelContainer[keyPath: keyPath] }
    }*/
}

