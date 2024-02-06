//
//  APIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI

struct MailFolderList : View {
    
    @Bindable
    var model: WindowViewModel
    
    @State
    var errorText = ""
    
    var body: some View {

        VStack {
            if !errorText.isEmpty {
                ScrollView {
                    ErrorText(errorText)
                }
            } else {
                HStack(spacing: 5) {
                    Text(model.account.username ?? "")
                    if model.isLoadingFolderTree {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)
                    }
                }
                List(model.rootChildren, children: \.children.nilIfEmpty, selection: $model.selectedMailFolder) { node in
                    Text(node.displayName)
                        .tag(node.element) // selection tag
                }
                
                /*Section("target mail folders", isExpanded: $isExpanded) {
                    OutlineGroup(
                        model.targetFolderTreeRootChildren,
                        id: \.value.rawValue,
                        children: \.children.nilIfEmpty
                    ) { item in
                        Text(item.value.rawValue)
                    }
                }*/
            }
        }
        .toolbar {
            Button("update", systemImage: "arrow.clockwise") {
                Task { await update() }
            }
            
            Button("sync", systemImage: "arrow.left.arrow.right") {
                Task { await sync() }
            }
        }
        .task {
            await update()
        }
    }
    
    func update() async {
        errorText = ""
        do {
            try await model.loadFolderTree()
        } catch {
            errorText = String(describing: error)
        }
    }
    
    func sync() async {
        errorText = ""
        do {
            try await model.syncFolderTree()
        } catch {
            errorText = String(describing: error)
        }
    }
}

extension Collection {
    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}


struct ErrorText : View {
    let text: any StringProtocol
    init(_ text: any StringProtocol) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(.red)
            .textSelection(.enabled)
    }
}
