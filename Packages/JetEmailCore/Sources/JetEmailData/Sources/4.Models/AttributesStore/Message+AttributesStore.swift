//
//  Message.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

@MainActor
public extension Message {
    var isBusy: Bool {
        get { resourceID.isBusy }
        set { resourceID.isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { resourceID.isClassifying }
        set { resourceID.isClassifying = newValue }
    }
    
    var movePlanID: MailFolderID? {
        get { resourceID.movePlanID }
        set { resourceID.movePlanID = newValue }
    }
}
