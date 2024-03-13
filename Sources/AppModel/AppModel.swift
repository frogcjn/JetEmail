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
import JetEmailData

import AuthenticationServices

// @dynamicMemberLookup
@MainActor // for @MainActor AppModel
@Observable
final class AppModel {

    let logger = Logger(subsystem: "me.frogcjn.jet-email", category: "AppModel")
    
    // Feature: Unselection - Will Sign Out Account
    var willSignOutAccount = PassthroughSubject<Account, Never>()
    
    var isBusy = false
    
    #if os(macOS)
    var mailWindow: NSWindow?
    #else
    var mailWindow: UIWindow?
    #endif
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

