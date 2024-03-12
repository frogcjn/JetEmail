//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public struct MailFolderSystemInfo : CodableValueType, Sendable {
    public let               order: Int?
    public let    nameLocalizedKey: String?
    public let         systemImage: String?
    
    public init(systemOrder: Int?, nameLocalizedKey: String?, systemImage: String?) {
        self.order            = systemOrder
        self.nameLocalizedKey = nameLocalizedKey
        self.systemImage      = systemImage
    }
}
