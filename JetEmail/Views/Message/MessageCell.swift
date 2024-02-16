//
//  MessageCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct MessageCell : View {
    
    @Environment(Message.self)
    var message
    
    var body: some View {
        VStack(alignment: .leading) {
            // Text(message.lement.sender?.emailAddress?.name ?? message.lement.sender?.emailAddress?.address ?? "")
            Text(message.subject ?? "").lineLimit(1)
            Text(message.receivedDate?.formattedRelative() ?? "")
            Text(message.bodyPreview ?? "").lineLimit(2)
        }
    }
}
