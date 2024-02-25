//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import SwiftData

extension AppModel {
    static let shared = AppModel()
}

extension Microsoft.Client {
    static var _shared: Microsoft.Client?
    static var shared: Microsoft.Client {
        get async throws {
            if let _shared { return _shared }
            let client = try await Task { @BackgroundActor in
                BackgroundActor.assertIsolated()
                return try Microsoft.Client()
            }.value
            _shared = client
            return client
        }
    }
}

extension Google.Client {
    static var shared = Google.Client()
}

extension ModelContainer {
    static var shared = try! ModelContainer(for: Account.self, MailFolder.self, Message.self)
}

extension SettingsModel {
    static var shared = SettingsModel()
}

extension AccountAttributesStore {
    static var shared = AccountAttributesStore()
}

extension MailFolder.AttributesStore {
    static var shared = MailFolder.AttributesStore()
}

extension Message.AttributesStore {
    static var shared = Message.AttributesStore()
}


@globalActor
@ModelActor
actor BackgroundModelActor {
    static var shared = BackgroundModelActor(modelContainer: .shared)
}

@globalActor
actor BackgroundActor {
    static let shared = BackgroundActor()
}


extension Google.Keychain {
    static let shared = Google.Keychain()
}
