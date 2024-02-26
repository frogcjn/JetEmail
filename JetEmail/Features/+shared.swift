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


/*
extension Google.Client {
    static var shared = Google.Client()
}
*/
extension ModelContainer {
    static var shared = try! ModelContainer(for: Account.self, MailFolder.self, Message.self)
}

extension SettingsModel {
    static var shared = SettingsModel()
}

extension Account.AttributesStore {
    static var shared = Account.AttributesStore()
}

extension MailFolder.AttributesStore {
    static var shared = MailFolder.AttributesStore()
}

extension Message.AttributesStore {
    static var shared = Message.AttributesStore()
}



/*
extension Google.Keychain {
    static let shared = Google.Keychain()
}
*/

import SwiftData

@globalActor
@ModelActor
public actor BackgroundModelActor {
    public static var shared = BackgroundModelActor(modelContainer: .shared)
}
