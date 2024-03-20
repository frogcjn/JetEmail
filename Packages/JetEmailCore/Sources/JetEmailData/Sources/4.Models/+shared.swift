//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import SwiftData

public extension ModelContainer {
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
