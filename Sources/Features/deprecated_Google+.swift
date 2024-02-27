//
//  ViewModel_.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData



// MARK: - AppModel: Account-MailFolders API

/*extension Account {
    var appModel: AppModel { .shared }
    
    // Feature: Accounts - Remove Account
    fileprivate func removeAccountForGoogle() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        guard let graphContext = graphID, let modelContext else { return }
        
        do {
            appModel.willSignOutAccount.send(self)
            
            _ = try await graphContext.removeAccount()
            _ = try modelContext.removeAccount(self)
        } catch {
            appModel.logger.error("\(error)")
        }
    }
}*/

/*extension AppModel {
    // Feature: Accounts - Move Accounts
    /// Move accounts to change their orders in `ModelContext`.
    /// - Parameters:
    ///   - accounts: original accounts array.
    ///   - source: An index set representing the offsets of all elements that should be moved.
    ///   - destination: The offset of the element before which to insert the moved elements. destination must be in the closed range 0...count.
    func moveAccounts(_ accounts: [JetEmail.Account], fromOffsets source: IndexSet, toOffset destination: Int) {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let modelContext = modelContainer.mainContext
            _ = try modelContext.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
        } catch {
            logger.error("\(error)")
        }
    }
}*/





/*
extension Google.Client {
    
   
    /*var session: MicrosoftClient.Session {
        get async throws {
            try await account.session
        }
    }*/
}
*/


//
