//
//  FolderList.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//
/*
import Foundation
import AppKit

struct TargetFolderPaths {
    
}

extension TargetFolderPaths {
    static var shared: [[FolderName]] = {
        let asset = NSDataAsset(name: "TargetFolderPaths", bundle: Bundle.main)!
        return try! asset.data.jsonDecode([[FolderName]].self)
    }()
    static var sharedTree: Tree<FolderName> = {
        let folders = shared
        let tree = Tree<FolderName>(rootValue: .special(.root))
        for path in folders {
            var current = tree.root
            for name in path {
                if let node = current.children.first(where: { $0.element == name }) {
                    current = node
                    continue
                } else {
                    let child = TreeNode(value: name)
                    current.children.append(child)
                    current = child
                }
            }
        }
        return tree
    }()
}
*/
/*
enum SpecialFolderName: String {
    case root = "root"
    case archive = "archive"
    case junkEmail = "junkemail"
    
    var graph: MSGraph.MailFolder.WellKnownFolderName {
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
*/

