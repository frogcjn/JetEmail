//
//  FolderList.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import Foundation
import AppKit

struct TargetFolderPaths {
    
}

extension TargetFolderPaths {
    static var shared: [[FolderName]] = {
        let asset = NSDataAsset(name: "TargetFolderPaths", bundle: Bundle.main)!
        return try! JSONDecoder().decode([[FolderName]].self, from: asset.data)
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


