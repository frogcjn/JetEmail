//
//  loadBody.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

// MARK: Feature: Message - Load Body

extension AppItemModel<Message> {
    // @MainActor // for .isBusy
    func loadBody() async {
        guard !isBusy else { return }
        isBusy = true
        print("loadBody start")

        defer { 
            isBusy = false
            print("loadBody end")
        }
        do {
            let message = item
            let account = message.mailFolder.account
            guard let session = try await account.refreshedIfExpiredSession else { return }
            
            switch session {
            case .microsoft(let session):
                guard case .microsoft(let messageID) = message.modelID else { return }
                
                let microsoftMessage = try await session.getMessage(microsoftID: messageID) // load from MSAL
                _ = try await BackgroundModelActor.shared.setMessage(microsoft: microsoftMessage, to: item.modelID) // MSAL to SwiftData
                
            case .google(let session):
                guard case .google(let messageID) = message.modelID else { return }
                var googleMessage = try await session.getMessage(id: messageID, format: .full)
                googleMessage.raw = try await session.getMessage(id: messageID, format: .raw).raw
                _ = try await BackgroundModelActor.shared.setMessage(google: googleMessage, to: item.modelID) // MSAL to SwiftData
            }
        } catch {
            logger.error("\(error)")
        }
    }
}

extension Google.Message {
    func _print() {
        print("id:", id) // 18dd9dd6644cb062
        print("threadId:", threadId ?? "nil") // nil
        print("labelIds:", labelIds ?? "nil") // nil
        print("historyId:", historyId ?? "nil") // nil
        print("internalDate:", internalDate ?? "nil") // 1708757181000
        print("sizeEstimate:", sizeEstimate ?? "nil") // nil
        print("snippet:", snippet ?? "nil") // Google Voice &lt;#&gt;BofA: DO NOT share this code. We will NEVER call you or text you for it. Code 484154. Reply HELP if you didn&#39;t request it. 如要回复此消息，请在移动设备或计算机上启动 Google Voice (https://voice.
        print("raw:", raw ?? "nil") // nil
        
        if let payload = payload {
            print("====payload====")
            payload._print()
        }
    }
}

extension Google.Message.Part {
    func _print() {
        print("partID:", partID ?? "nil") // nil
        print("mimeType:", mimeType ?? "nil") // nil
        print("filename:", filename ?? "nil") // nil
        print("headers:", headers?.map { $0.name } ?? "nil") // ["Delivered-To", "Received", "X-Received", "ARC-Seal", "ARC-Message-Signature", "ARC-Authentication-Results", "Return-Path", "Received", "Received-SPF", "Authentication-Results", "DKIM-Signature", "X-Google-DKIM-Signature", "X-Gm-Message-State", "X-Google-Smtp-Source", "MIME-Version", "X-Received", "Message-ID", "Date", "Subject", "From", "To", "Content-Type"]
        print("body:", body ?? "nil") // nil
        
        if let parts = parts {
            for (id, part) in parts.enumerated() {
                print("====part[\(id)]====")
                part._print()
            }
        }
    }
}
