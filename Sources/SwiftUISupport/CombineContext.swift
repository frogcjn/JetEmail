//
//  MSALAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import Observation

//@dynamicMemberLookup
@MainActor
@Observable
class CombineContext<Context, Item> {
    
    let context: Context
    let item: Item
    
    init(context: Context, item: Item) {
        self.context = context
        self.item = item
    }
}

// @dynamicMemberLookup
/*extension CombineContext {
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Item, Value>) -> Value {
        item[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Item, Value>) -> Value {
        _read { yield item[keyPath: keyPath] }
        _modify { var model = item; yield &model[keyPath: keyPath] }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Context, Value>) -> Value {
        context[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Context, Value>) -> Value {
        _read { yield context[keyPath: keyPath] }
        _modify { var AppModel = context; yield &AppModel[keyPath: keyPath] }
    }
    
    /*subscript<Value>(dynamicMember keyPath: WritableKeyPath<AppModel, Value>) -> Value {
        //get { AppModel[keyPath: keyPath] }
        // set { AppModel[keyPath: keyPath] = newValue }
        _read {
            yield AppModel[keyPath: keyPath]
        }
        _modify {
            yield &AppModel[keyPath: keyPath]
        }
    }*/
    
    /*subscript<Value>(dynamicMember keyPath: KeyPath<MSGraph.MailFolder.RequestBuilder, Value>) -> Value {
        requestMailFolders[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<MSGraph.MailFolder.RequestBuilder, Value>) -> Value {
        get { requestMailFolders[keyPath: keyPath] }
        set { requestMailFolders[keyPath: keyPath] = newValue }
    }*/
}*/



/*@dynamicMemberLookup
@Observable
class AccountContext {
    
    var AppModel: AppModel
    var model: Account
    
    
    init(_ appViewModel: AppModel, _ model: Account) {
        self.AppModel = appViewModel
        self.model = model
        
        requestMailFolders = .init()
        requestMailFolders.accountContext = self
    }
    
    // var isBusy = false
    var requestMailFolders: MSGraph.MailFolder.RequestBuilder
}*/

/*extension AccountContext {
    
    // account view models
    private static var _contexts: [Account: AccountContext] = [:]

    static subscript(model: Account) -> AccountContext? {
        get {
            
            guard let AppModel = AppModel., !model.isDeleted else { return nil }
            
            if let context = _contexts[model] { return context }
            
            let context = AccountContext(AppModel, model)
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

