//
//  MessageCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import class JetEmailFoundation.TreeNode
import JetEmailData        // for Account
import JetEmailPlatform

extension MessageCell {
    struct MovePlan: View {
        
        @Environment(AppModel.self)
        var appModel

        @Environment(Account.self)
        var account
        
        @Environment(MailFolder.self)
        var mailFolder
        
        @Environment(Message.self)
        var message
        
        @Environment(\.backgroundProminence)
        var backgroundProminence
        
        enum MovePlanStyle {
            case menu
            case picker
            case roundedRect
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
            } else if let _ = message.movePlanID {
                //VStack(alignment: .leading) {
                HStack {
                    switch style {
                    case .menu:
                        Text("Move To: ")
                        MenuGroup(data: account.root?.children ?? [], children: \.children.nilIfEmpty) { element in
                            Label(element.localizedName, systemImage: element.systemImage)//.frame(width: 40)
                        } primaryLabel: {
                            if let movePlanID = message.movePlanID, let movePlan = try? appModel.mainContext[movePlanID] {
                                HStack {
                                    Label("/" + movePlan.path.joined(separator: "/"), systemImage: movePlan.systemImage)
                                }
                            }
                        } selection: { element in
                            message.movePlanID = element.resourceID
                        } primaryAction: {
                            appModel.moveMessageToMovePlan(message, in: mailFolder, account)
                        }
                        .menuStyle(.button)
                        .labelStyle(.titleAndIcon)
                        .truncationMode(.middle)
                        Spacer()
                        Button("Cancel Moving", systemImage: "xmark.circle.fill") {
                            message.movePlanID = nil
                        }
                        .buttonStyle(.borderless)
                        .labelStyle(.iconOnly)
                    case .picker:
                        Picker(selection: Bindable(message).movePlanID) {
                            ForEach(selectionRange(), id: \.element.id) {
                                Label($0.path.joined(separator: "/"), systemImage: $0.element.systemImage).tag(Optional($0.element.resourceID))
                            }
                        } label: {
                            Button("Move To: ", systemImage: "folder") {
                                appModel.moveMessageToMovePlan(message, in: mailFolder, account)
                            }
                        }
                        .labelStyle(.titleAndIcon)
                        
                        Spacer()
                        Button("Cancel Moving", systemImage: "xmark.circle.fill") {
                            message.movePlanID = nil
                        }
                        .buttonStyle(.borderless)
                        .labelStyle(.iconOnly)
                    case .roundedRect:
                        if let movePlanMailFolderID = message.movePlanID, let movePlanMailFolder = try? appModel.mainContext[movePlanMailFolderID] {
                                
                            Button("Cancel Moving", systemImage: "xmark.circle.fill") {
                                message.movePlanID = nil
                            }
                            .buttonStyle(.borderless)
                            .labelStyle(.iconOnly)
                            
                            Button {
                                appModel.moveMessageToMovePlan(message, in: mailFolder, account)
                            } label: {
                                Label("/" + movePlanMailFolder.path.joined(separator: "/"), systemImage: movePlanMailFolder.systemImage)
                                    .foregroundStyle(foregroundColor)
                            }
                            .environment(\.backgroundProminence, .standard)
                            
                            /*MenuGroup(data: account.root?.children ?? [], children: \.children.nilIfEmpty) { element in
                                Label(element.localizedName, systemImage: element.systemImage)//.frame(width: 40)
                            } primaryLabel: {
                                if let movePlanID = message.movePlanID, let movePlan = try? appModel.mainContext[movePlanID] {
                                    HStack {
                                        Label("/" + movePlan.path.joined(separator: "/"), systemImage: movePlan.systemImage)
                                    }
                                }
                            } selection: { element in
                                message.movePlanID = element.resourceID
                            } primaryAction: {
                                appModel.moveMessageToMovePlan(message, in: mailFolder, account)
                            }
                            .menuStyle(.button)
                            .labelStyle(.titleAndIcon)
                            .truncationMode(.middle)
                            .environment(\.backgroundProminence, .standard)*/

                            //.buttonStyle(.)
                                
                            
                            /*.padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(
                                        style: StrokeStyle(
                                            lineWidth: 2,
                                            dash: [4],
                                            dashPhase: 0
                                        )
                                    )
                            )*/
                        }
                    }
                   

                }
            }
        }
        
        var foregroundColor : Color {
            backgroundProminence == .increased ? .primary : .blue
        }
    }
}
