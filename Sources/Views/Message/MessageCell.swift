//
//  MessageCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Foundation
import JetEmail_Data

struct MessageCell : View {
    
    @Environment(Message.self)
    var message
        
    var body: some View {
        VStack(alignment: .leading) {
            // Text(message.lement.sender?.emailAddress?.name ?? message.lement.sender?.emailAddress?.address ?? "")
            HStack {
                Text(message.senderField ?? "(No Sender)").lineLimit(1)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(message.date?.formattedRelative() ?? "(No Date)")
            }
            Text(message.subject ?? "(No Subject)").lineLimit(1)
                .fontWeight(.medium)
            Text(message.bodyPreview ?? "(No Preview)").lineLimit(2)
                .foregroundStyle(.secondary)
            
            MovePlan(style: .menu)
        }
    }
}


