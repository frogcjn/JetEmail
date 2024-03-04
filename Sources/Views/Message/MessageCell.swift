//
//  MessageCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Foundation

struct MessageCell : View {
    
    @Environment(Message.self)
    var message
        
    

    var body: some View {
        VStack(alignment: .leading) {
            // Text(message.lement.sender?.emailAddress?.name ?? message.lement.sender?.emailAddress?.address ?? "")
            Text(message.subject ?? "").lineLimit(1)
            Text(message.date?.formattedRelative() ?? "")
            Text(message.bodyPreview ?? "").lineLimit(2)
            
            MoveTo()
        }
    }
}


struct MoveTo: View {
    
    @Environment(AppItemModel<Message>.self)
    var itemModel
    
    @Environment(Message.self)
    var message
            
    func selectionRange() -> [TreeNode<MailFolder>] {
        guard let root = message.mailFolder.account.mailFolderTree?.root else { return [] }
        let desendants = root.descendants(includesSelf: false)
        return desendants
    }
    
    var body: some View {
        if let _ = message.moveTo {
            //VStack(alignment: .leading) {
            HStack {
                //Toggle(isOn: $isSelectedToMove) {
                //HStack {
                
                Picker(selection: Bindable(message).moveTo) {
                    Text("").tag(MailFolder?.none)
                    ForEach(selectionRange(), id: \.modelID) {
                        Text($0.path.joined(separator: "/")).tag(Optional($0.element))
                    }
                } label: {
                    Button("move") {
                        if let mailFolder = message.moveTo {
                            Task {
                                await itemModel.moveTo(mailFolder: mailFolder)
                                message.moveTo = nil
                            }
                        }
                    }
                }
                
                //}
                //}
                Spacer()
                Button("don't move", systemImage: "xmark.circle.fill") {
                    message.moveTo = nil
                }.buttonStyle(.borderless)
            }
        }
    }
}
