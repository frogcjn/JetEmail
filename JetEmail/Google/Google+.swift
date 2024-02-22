//
//  ViewModel_.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData
import AppAuth
import GTMAppAuth
import AppKit



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
            appModel.willRemoveAccount.send(self)
            
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




extension String {
    var fourCharUInt32: UInt32? {
        guard count == 4 else {
            print("Input must be exactly four characters.")
            return nil
        }
        
        var value: UInt32 = 0
        for (index, char) in utf8.enumerated() {
            value += UInt32(char) << (8 * (3 - index))
        }
        
        return value
    }
}


extension Google.Client {
    
   
    /*var session: MicrosoftClient.Session {
        get async throws {
            try await account.session
        }
    }*/
}



//
/*
 errSecSuccess                               = 0,       /* No error. */
 errSecUnimplemented                         = -4,      /* Function or operation not implemented. */
 errSecIO                                    = -36,     /*I/O error (bummers)*/
 errSecOpWr                                  = -49,     /*file already open with with write permission*/
 errSecParam                                 = -50,     /* One or more parameters passed to a function where not valid. */
 errSecAllocate                              = -108,    /* Failed to allocate memory. */
 errSecUserCanceled                          = -128,    /* User canceled the operation. */
 errSecBadReq                                = -909,    /* Bad parameter or invalid state for operation. */
 errSecInternalComponent                     = -2070,
 errSecNotAvailable                          = -25291,  /* No keychain is available. You may need to restart your computer. */
 errSecDuplicateItem                         = -25299,  /* The specified item already exists in the keychain. */
 errSecItemNotFound                          = -25300,  /* The specified item could not be found in the keychain. */
 errSecInteractionNotAllowed                 = -25308,  /* User interaction is not allowed. */
 errSecDecode                                = -26275,  /* Unable to decode the provided data. */
 errSecAuthFailed                            = -25293,  /* The user name or passphrase you entered is not correct. */
 */
