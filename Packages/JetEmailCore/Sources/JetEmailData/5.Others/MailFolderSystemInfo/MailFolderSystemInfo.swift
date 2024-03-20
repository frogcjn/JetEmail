//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import Foundation

public struct MailFolderSystemInfo : CodableValueType, Sendable {
    public let               order: Int?
    public let    nameLocalizedKey: String?
    public let         systemImage: String?
    
    public init(systemOrder: Int?, nameLocalizedKey: String?, systemImage: String?) {
        self.order            = systemOrder
        self.nameLocalizedKey = nameLocalizedKey
        self.systemImage      = systemImage
    }
    
    public static func localizedName(name: String?, localizedKey: String?) -> String {
        if let localizedKey {
            let localizedName = String(localized: .init(localizedKey), bundle: .module)
            
            // found localized key
            if localizedName != localizedKey {
                return localizedName
            }
        }
        
        return name?.nilIfEmpty ?? String(localized: "(MailFolder.NoName)", defaultValue: .init(name ?? ""))
    }
}
