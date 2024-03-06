//
//  MessageCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Foundation

extension MessageCell {
    struct MoveTo: View {
        
        @Environment(AppItemModel<Message>.self)
        var itemModel
        
        @Environment(MailFolder.self)
        var moveFrom
        
        @Environment(Message.self)
        var message
        
        func selectionRange() -> [TreeNode<MailFolder>] {
            guard let root = message.mailFolder.account.mailFolderTree?.root else { return [] }
            let desendants = root.descendants(includesSelf: false)
            return desendants
        }
        
        var body: some View {
            if message.isClassifying {
                HStack(spacing: 5) {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular).controlSize(.small)
                    Text("Auto Classifying…")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            } else if let _ = message.moveTo {
                //VStack(alignment: .leading) {
                HStack {
                    //Toggle(isOn: $isSelectedToMove) {
                    //HStack {
                    
                    Picker(selection: Bindable(message).moveTo) {
                        Image(systemName: "xmark.circle.fill").tag(MailFolder?.none)
                        ForEach(selectionRange(), id: \.modelID) {
                            Text($0.path.joined(separator: "/")).tag(Optional($0.element))
                        }
                    } label: {
                        Button("Move To:", systemImage: "folder") {
                            if let moveTo = message.moveTo {
                                Task {
                                    await itemModel.move(from: moveFrom, to: moveTo)
                                    message.moveTo = nil
                                }
                            }
                        }.labelStyle(.titleAndIcon)
                    }
                    
                    //}
                    //}
                    Spacer()
                    Button("Cancel Moving", systemImage: "xmark.circle.fill") {
                        message.moveTo = nil
                    }.buttonStyle(.borderless)
                }
            }
        }
    }
}
