//
//  Message.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

@MainActor
public extension Message {
    var isMoving: Bool {
        get { resourceID.isMoving }
        set { resourceID.isMoving = newValue }
    }
    
    var isLoadingBody: Bool {
        get { resourceID.isLoadingBody }
        set { resourceID.isLoadingBody = newValue }
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
