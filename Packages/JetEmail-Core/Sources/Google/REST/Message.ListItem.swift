//
//  Message.ListItem.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

extension Message {
    struct ListItem {
        let id      : Message.ID
        let threadID: String?
    }
    
    var listItem: ListItem {
        .init(
            id      : id,
            threadID: threadId
        )
    }
}

