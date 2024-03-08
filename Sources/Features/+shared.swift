//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import SwiftData
import Foundation
import JetEmail_Data

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

extension ModelStore {
    public static var instance: ModelStore {
        get async {
            await ModelStore(modelContainer: .shared)
        }
    }
}

