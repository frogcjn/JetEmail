//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import SwiftData
import Foundation
import JetEmailData

extension AppModel {
    static let shared = AppModel()
}

extension ModelContainer {
    @MainActor
    static var shared = {
        do {
            return try ModelContainer(for: Account.self, MailFolder.self, Message.self)
        } catch {
            print(error)
            fatalError()
        }
    }()
}

extension SettingsModel {
    static var shared = SettingsModel()
}

import SwiftData

@ModelStoreActor
extension ModelStore {
    
    static var _shared: ModelStore?
    
    public static var shared: ModelStore { get async {
        if let _shared { return _shared }
        let modelStore = await ModelStore(modelContainer: .shared)
        _shared = modelStore
        return modelStore
    } }
}

@globalActor
actor ModelStoreActor : Actor {
    static let shared = ModelStoreActor()
}

