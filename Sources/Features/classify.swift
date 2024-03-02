//
//  Classify.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import OpenAI
import Microsoft
import Google
import JetEmail_Foundation

enum Agent {
    
}

extension Account {
    var mailFolderTree: Tree<MailFolder>? {
        guard let root = root else { return nil }
        let tree = Tree(rootElement: root)
        var queue = [tree.root]
        while !queue.isEmpty {
            let currentNode = queue.removeFirst()
            
            let children = currentNode.element.children.filter { !$0.deleteMark }
            let childrenNode = children.map{ TreeNode(parent: currentNode, element: $0) }
            currentNode.children = childrenNode
            queue.append(contentsOf: childrenNode)
        }
        return tree
    }
}


extension AppItemModel<Message> {
    
    func classify() async {
        guard !self.isClassifying else { return }
        self.isClassifying = true
        defer { self.isClassifying = false }
        
        
        let message = item
        let account = message.mailFolder.account
        do {
            guard let session = account.session else { return }
            switch session {
            case .microsoft(let session): try await session.classify(account: account, message: message)
            case .google(let session): try await session.classify(account: account, message: message)
            }
        } catch {
            context.logger.log("\(error)")
        }
    }
    
}

extension Microsoft.Session {
    func classify(account: Account, message: Message) async throws {
        guard let root = account.mailFolderTree?.root else { return }
        
        // get "archive", "junk" mail folders
        let archiveMailFolder = try await getMailFolder(wellKnownFolderName: Microsoft.MailFolder.WellKnownFolderName.archive)
        let junkMailFolder = try await getMailFolder(wellKnownFolderName: .junkEmail)
       
        guard
            let archiveNode = root.children.first(where: { $0.modelID == archiveMailFolder.modelID }),
            let junkNode = root.children.first(where: { $0.modelID == junkMailFolder.modelID })
        else {
            throw ClassifyError.noArchiveFolder
        }
        
        let archiveDesendants = archiveNode.descendants(includesSelf: false)
        let folders = archiveDesendants.map(\.path) + [junkNode.path]
        message.classifyResultText = try await Agent.classify(folders: folders, message: message) ?? "nil"
    }
}

extension Google.Session {
    func classify(account: Account, message: Message) async throws {
        guard let root = account.mailFolderTree?.root else { return }
        let desendants = root.descendants(includesSelf: false)
        let folders = desendants.map(\.path)
        message.classifyResultText = try await Agent.classify(folders: folders, message: message) ?? "nil"
    }
}

fileprivate extension TreeNode<MailFolder> {
    var path: [String] {
        Array(sequence(first: self) { $0.parent }.map(\.name).reversed().dropFirst())
    }
}

extension Agent {
    static func classify(folders: [[String]], message: Message) async throws -> String? {
        let folderDescriptions = folders.enumerated().map { "\($0.offset): \($0.element.joined(separator: "/"))" }
        let openAI = OpenAI(apiToken: "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")
        print(folderDescriptions.joined(separator: "\n"))
        
        let messages: [Chat] =  [
            .init(role: .system, content: "You are an email classifier agent, you need classify my email into different folders."),
            .init(role: .user, content: """
                What is best folder for this email:
                    from: \(message.from.debugDescription)")
                    subject: \(message.subject ?? "nil")
                    bodyPreview: \(message.bodyPreview ?? "nil")
                
                Please put it with a right folder.
                """
            )
        ]
        
        let tools: [ChatTool] = [
            .init(
                type: .function,
                function: .init(
                    name: "put_email_into_folder",
                    description: "Put email into a folder. If you want to put to existed folder, just fill the `existed_folder` property with the existed folder description, otherwise, if you want to create new folder or not sure which folder it should be put, don't fill `existed_folder` property.",
                    parameters: .init(
                        type: .object,
                        properties: [
                            "existed_folder": .init(
                                type: .string,
                                enumValues: folderDescriptions
                            )
                        ]
                    )
                )
            )
        ]
        
        let query = ChatQuery(model: .gpt4, messages: messages, tools: tools)
        let response = try await openAI.chats(query: query)
        print(response.choices[0].message)
        return (try? response.choices[0].message.toolCalls?.first?.function.arguments?.decodeJSON(ClassifyResult.self))?.existedFolder
    }
}

