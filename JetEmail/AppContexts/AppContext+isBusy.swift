//
//  Model+isBusy.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import Observation
/*
@Observable
@MainActor
class BusyRecorder {
    var busyAccounts: Set<Account> = []
    var busyMailFolders: Set<MailFolder> = []
    var busyMessages: Set<Message> = []
}

extension BusyRecorder {
    subscript(isBusyAccount account: Account) -> Bool {
        get { _busyAccounts.contains(account) }
        set { if newValue { _busyAccounts.insert(account) } else { _busyAccounts.remove(account) } }
    }
    
    @MainActor
    subscript(isBusyMailFolder mailFolder: MailFolder) -> Bool {
        get { _busyMailFolders.contains(mailFolder) }
        set { if newValue { _busyMailFolders.insert(mailFolder) } else { _busyMailFolders.remove(mailFolder) }
        }
    }
    
    @MainActor
    subscript(isBusyMessage message: Message) -> Bool {
        get { _busyMessages.contains(message) }
        set { if newValue { _busyMessages.insert(message) } else { _busyMessages.remove(message) } }
    }
}

extension AppContext {
    
   /*@MainActor
    var accounts: [Account] {
        (try? modelContainer.mainContext.fetchAccounts()) ?? []
    }*/
    
    //@MainActor
    //var isSubpartBusy: Bool { isBusy || accounts.contains { AppContext.Item(context: self, item: $0).isSubpartBusy } }
}

extension Account {
    
    @MainActor
    func isBusy(_ context: AppContext) -> Bool { AppContext.Item(context: context, item: self).isBusy }
    
    //@MainActor
    //func isSubpartBusy(_ context: AppContext) -> Bool { AppContext.Item(context: context, item: self).isSubpartBusy }
}

extension AppContext.Item<Account> {
    @MainActor
    var isBusy: Bool {
        _read { yield context.busyRecorder[isBusyAccount: item] }
        _modify { yield &context.busyRecorder[isBusyAccount: item] }
    }
    
    //@MainActor
    //var isSubpartBusy: Bool { isBusy || item.mailFolders.contains { AppContext.Item(context: context, item: $0).isSubpartBusy } }
}

extension AppContext.Item<MailFolder> {
    @MainActor
    var isBusy: Bool {
        _read { yield context.busyRecorder[isBusyMailFolder: item] }
        _modify { yield &context.busyRecorder[isBusyMailFolder: item] }
    }
    
    //@MainActor
    //var isSubpartBusy: Bool { isBusy || item.messages.contains { AppContext.Item(context: context, item: $0).isSubpartBusy } }
}

extension AppContext.Item<Message> {
    @MainActor
    var isBusy: Bool {
        _read { yield context.busyRecorder[isBusyMessage: item] }
        _modify { yield &context.busyRecorder[isBusyMessage: item] }
    }
    
    //@MainActor
    //var isSubpartBusy: Bool { isBusy }
}*/

/*enum AppContextBusyTask : Hashable {
    case addingAccounts
    case addingMailFolders (Account)
    case addingMessages    (MailFolder)
    
    case modifyingAccounts
    case modifyingAccount   (Account)
    case modifyingMailFolder(MailFolder)
    case modifyingMessage   (Message)

    case removingAccounts                // affect accounts, mailFolders, messages, properties
    case removingAccount    (Account)
    case removingMailFolder (MailFolder)    // affact           mailFolders, messages, properties
    case removingMessage    (Message) // affect                        messages, properties
    
    /*func shouldStart(status: Set<AppContextBusyTask>) -> Bool {
        switch self {
        case .loadingAccounts:
            return status.isEmpty
        case .removeAccount(let account):
            if status.contains(.removeAccount(account)) { return false }
            if status.contains(.loadingAccounts) { return false }
            if status.contains(.movingAccounts) { return false }
            if status.contains(.loadingMailFolders) {
                
            }
            
        }
    }*/
}*/
