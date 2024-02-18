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
class AppContext {
    // MSAL
    let graphClient: MSGraph.Client
    let googleAPIClient: GoogleAPI.Client

    // Model
    let modelContainer: ModelContainer
    
    init(graphContext: MSGraph.Client, googleAPIClient: GoogleAPI.Client, modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.graphClient    = graphContext
        self.googleAPIClient = googleAPIClient
    }
    
    var logger = Logger(subsystem: "me.frogcjn.jet-email", category: "AppContext")
    var willRemoveAccount = PassthroughSubject<Account, Never>()
    //@MainActor
    //var busyRecorder = BusyRecorder()
    
    @MainActor
    var isBusy = false
}


// @dynamicMemberLookup
extension AppContext {

    // MSAL
    subscript<Value>(dynamicMember keyPath: KeyPath<MSGraph.Client, Value>) -> Value {
        graphClient[keyPath: keyPath]
    }

    subscript<Value>(dynamicMember keyPath: WritableKeyPath<MSGraph.Client, Value>) -> Value {
        _read { yield graphClient[keyPath: keyPath] }
        _modify { var graphContext = graphClient; yield &graphContext[keyPath: keyPath] }
    }
    
    // Model
    subscript<Value>(dynamicMember keyPath: KeyPath<ModelContainer, Value>) -> Value {
        modelContainer[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<ModelContainer, Value>) -> Value {
        _read { yield modelContainer[keyPath: keyPath] }
        _modify { var modelContainer = modelContainer; yield &modelContainer[keyPath: keyPath] }
    }
}

// AppContext -> AccountContext
// AppContext -> WindowViewModel -> MailFolderViewModel
