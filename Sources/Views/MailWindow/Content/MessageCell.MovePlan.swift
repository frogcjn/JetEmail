//
//  MessageCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Foundation
import JetEmail_Data

extension MessageCell {
    struct MovePlan: View {
        
        @Environment(AppItemModel<Message>.self)
        var itemModel
        
        @Environment(MailFolder.self)
        var moveFrom
        
        @Environment(Message.self)
        var message
        
        @Environment(Account.self)
        var account
        
        enum MovePlanStyle {
            case menu
            case picker
        }
        
        let style: MovePlanStyle
        
        func selectionRange() -> [TreeNode<MailFolder>] {
            guard let root = account.mailFolderTree?.root else { return [] }
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
            } else if let _ = message.movePlan {
                //VStack(alignment: .leading) {
                HStack {
                    switch style {
                    case .menu:
                        HStack {
                            Text("Move To: ")
                            MenuGroup(data: account.root?.children ?? [], children: \.children.nilIfEmpty, selection: Bindable(message).movePlan) { element in
                                Label(element.localizedName, systemImage: element.systemImage)//.frame(width: 40)
                            } primaryLabel: {
                                if let movePlan = message.movePlan {
                                    HStack {
                                        Label("/" + movePlan.path.joined(separator: "/"), systemImage: movePlan.systemImage)
                                    }
                                }
                            } action: {
                                moveTo()
                            }
                            .menuStyle(.button)
                            .labelStyle(.titleAndIcon)
                            .truncationMode(.middle)
                            Spacer()
                        }
                    case .picker:
                        Picker(selection: Bindable(message).movePlan) {
                            ForEach(selectionRange(), id: \.element.id) {
                                Label($0.path.joined(separator: "/"), systemImage: $0.element.systemImage).tag(Optional($0.element))
                            }
                        } label: {
                            Button("Move To: ", systemImage: "folder", action: moveTo)
                        }
                        .labelStyle(.titleAndIcon)
                    }
                   
                    Spacer()
                    Button("Cancel Moving", systemImage: "xmark.circle.fill") {
                        message.movePlan = nil
                    }
                    .buttonStyle(.borderless)
                    .labelStyle(.iconOnly)
                }
            }
        }
        
        @MainActor
        func moveTo() {
            guard let movePlan = message.movePlan else { return }
            Task {
                await itemModel.move(from: moveFrom, to: movePlan)
                message.movePlan = nil
            }
        }
    }
}

