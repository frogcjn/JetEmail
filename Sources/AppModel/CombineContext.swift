//
//  MSALAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import Foundation
import MSAL
import Observation
import SwiftData

@dynamicMemberLookup
@Observable
class ItemContext<Context, Item> {
    let context: Context
    let item: Item
    
    init(context: Context, item: Item) {
        self.context = context
        self.item = item
    }
}

// @dynamicMemberLookup
extension ItemContext {
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Model, Value>) -> Value {
        model[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Model, Value>) -> Value {
        _read { yield model[keyPath: keyPath] }
        _modify { var model = model; yield &model[keyPath: keyPath] }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Context, Value>) -> Value {
        context[keyPath: keyPath]
    }
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Context, Value>) -> Value {
        _read { yield context[keyPath: keyPath] }
        _modify { var appContext = context; yield &appContext[keyPath: keyPath] }
    }
    
    /*subscript<Value>(dynamicMember keyPath: WritableKeyPath<AppContext, Value>) -> Value {
        //get { appContext[keyPath: keyPath] }
        // set { appContext[keyPath: keyPath] = newValue }
        _read {
            yield appContext[keyPath: keyPath]
        }
        _modify {
            yield &appContext[keyPath: keyPath]
        }
    }*/
    
    /*subscript<Value>(dynamicMember keyPath: KeyPath<MSAL.MailFolder.RequestBuilder, Value>) -> Value {
        requestMailFolders[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<MSAL.MailFolder.RequestBuilder, Value>) -> Value {
        get { requestMailFolders[keyPath: keyPath] }
        set { requestMailFolders[keyPath: keyPath] = newValue }
    }*/
}



/*@dynamicMemberLookup
@Observable
class AccountContext {
    
    var appContext: AppContext
    var model: Account
    
    
    init(_ appViewModel: AppContext, _ model: Account) {
        self.appContext = appViewModel
        self.model = model
        
        requestMailFolders = .init()
        requestMailFolders.accountContext = self
    }
    
    // var isBusy = false
    var requestMailFolders: MSAL.MailFolder.RequestBuilder
}*/

/*extension AccountContext {
    
    // account view models
    private static var _contexts: [Account: AccountContext] = [:]

    static subscript(model: Account) -> AccountContext? {
        get {
            
            guard let appContext = AppContext.shared, !model.isDeleted else { return nil }
            
            if let context = _contexts[model] { return context }
            
            let context = AccountContext(appContext, model)
            _contexts[model] = context
            return context
        }
        
        set {
            _contexts[model] = newValue
        }
    }
}

extension Account {
    /*var isBusy: Bool {
        context?.isBusy ?? false
    }*/
    
    var context: AccountContext? {
        AccountContext[self]
    }
}

extension AccountContext : Identifiable {
    var id: Account.ID {
        self.model.id
    }
}*/

