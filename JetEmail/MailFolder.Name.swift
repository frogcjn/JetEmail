//
//  MailFolder.Name.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

// MARK: MailFolder.WellknownFolderName

extension Microsoft.Graph.MailFolder {
    // Well-known folder names https://learn.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0#methods
    
    enum WellKnownFolderName : String {
        case msgFolderRoot = "msgfolderroot"
        case archive = "archive"
        case junkEmail = "junkemail"
    }
}

enum SpecialFolderName: String {
    case root = "root"
    case archive = "archive"
    case junkEmail = "junkemail"
    
    var graph: Microsoft.Graph.MailFolder.WellKnownFolderName {
        switch self {
        case .root: .msgFolderRoot
        case .archive: .archive
        case .junkEmail: .junkEmail
        }
    }
}

enum FolderName : Codable, RawRepresentable {
    
    case display(String)
    case special(SpecialFolderName)
    
    /*init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self.init(rawValue: rawValue)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }*/
    
    init?(rawValue: String) {
        if rawValue.starts(with: "$") {
            let rawValue = String(rawValue.dropFirst())
            self = .special(.init(rawValue: rawValue)!)
        } else {
            self = .display(rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .display(let name): name
        case .special(let specialName): "$" + specialName.rawValue
        }
    }
}
