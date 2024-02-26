//
//  Google.Message.ListItem.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

extension Google.Message {
    struct ListItem {
        let id      : Google.Message.ID
        let threadID: String?
    }
    
    var listItem: ListItem {
        .init(
            id      : id,
            threadID: threadId
        )
    }
}

