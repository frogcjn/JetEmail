//
//  AppViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import class  Combine.PassthroughSubject
import struct os.Logger
import SwiftData        // for ModelContainer, ModelContext, Observable
import JetEmailData       // for AccountID
import JetEmailPlatform // for ModelStore

// @dynamicMemberLookup
@MainActor // for @MainActor AppModel
@Observable
final class AppModel {
    var isBusy = false
    let logger = Logger(subsystem: "me.frogcjn.jet-email.AppModel", category: "AppModel")
    
    // Feature: Unselection - Will Sign Out Account
    let willSignOutAccount = PassthroughSubject<AccountID, Never>()

}


extension AppModel {
    var     clients: Clients      { get       {       .shared       } }
    var  modelStore: ModelStore   { get async { await .shared       } }
    var mainContext: ModelContext { ModelContainer.shared.mainContext }
}
