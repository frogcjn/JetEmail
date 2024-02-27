//
//  Classify.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import OpenAI
import Microsoft

struct Agent {
    
}

extension TreeNode<Microsoft.MailFolder> {
    var path: [String] {
        [] // Array(sequence(first: self) { $0.parent }.map(\.displayName).reversed().dropFirst())
    }
}

extension Agent {
    static func classify(archiveNode: TreeNode<Microsoft.MailFolder>, junkNode: TreeNode<Microsoft.MailFolder>, message: Microsoft.Message) async throws -> String? {

        
        let archiveDesendants = archiveNode.descendants(includesSelf: false)
        let folders = archiveDesendants.map(\.path) + [junkNode.path]
        let folderDescriptions = folders.enumerated().map { "\($0.offset): \($0.element)" }
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
        return (try? response.choices[0].message.toolCalls?.first?.function.arguments?.decodeJSON(ClassifyResult.self))?.existedFolder
    }
}

