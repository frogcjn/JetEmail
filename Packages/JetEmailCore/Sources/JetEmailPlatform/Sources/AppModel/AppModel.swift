//
//  AppViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import class  Combine.PassthroughSubject
import struct os.Logger
import SwiftData        // for ModelContainer, ModelContext, Observable
import JetEmailData     // for AccountID

// @dynamicMemberLookup
@MainActor // for @MainActor AppModel
@Observable
public final class AppModel {
    public var isBusy = false
    public let logger = Logger(subsystem: "me.frogcjn.jet-email.AppModel", category: "AppModel")
    
    // Feature: Unselection - Will Sign Out Account
    public let willSignOutAccount = PassthroughSubject<AccountID, Never>()
    
    public static let shared = AppModel()
}

public extension AppModel {
    var    sessions: [Session]    { get async throws { try await Clients.shared.sessions           } }
    var  modelStore: ModelStore   { get async        {     await .shared                           } }
    var mainContext: ModelContext                    {           ModelContainer.shared.mainContext }
}
