//
//  SignOut.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Sign Out

extension AppItemModel<Account> {

    // @MainActor // for isAppModelBusy, item.isBusy
    func signOut() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
                
        let model = item
        
        // Feature: Unselection - Will Sign Out Account
        context.willSignOutAccount.send(model)
        
        do {

            _ = try await item.session?.signOut()
            item.session = nil
            _ = try await BackgroundModelActor.shared.deleteAccount(itemModel: self, id: item.persistentID)
        } catch {
            logger.error("\(error)")
        }
    }
}

extension Session {
    func signOut() async throws -> Session {
        switch self {
        case .microsoft(let platformSession): _ = try await platformSession.signOut()
        case .google(let platformSession): _ = try await platformSession.signOut()
        }
        return self
    }
}

extension Microsoft.Session {
    func signOut() async throws -> Microsoft.Session {
        _ = try await Microsoft.Client.shared._msalSignout(msalAccount: _msalSession.account)
        return self
    }
}

extension Google.Session {
    func signOut() async throws -> Google.Session {
        _ = try await item.deleteFrom(keychain: Google.Keychain.shared)
        return self
    }
}
