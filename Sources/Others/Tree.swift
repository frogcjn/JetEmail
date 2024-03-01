//
//  Tree.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

class Tree<Value> {
    var root: TreeNode<Value>
    
    init(rootElement: Value) {
        self.root = TreeNode(element: rootElement)
    }
    
    init(root: TreeNode<Value>) {
        self.root = root
    }
}

extension TreeNode {
    func descendants(includesSelf: Bool = true) -> [TreeNode<Element>] {
        var queue: [TreeNode<Element>] = [self]
        var result: [TreeNode<Element>] = []
        while !queue.isEmpty {
            let current = queue.removeFirst()
            result.append(current)
            queue.append(contentsOf: current.children)
        }
        if includesSelf {
            return result
        } else {
            return Array(result.dropFirst())
        }
    }
}
    

@dynamicMemberLookup
class TreeNode<Element> {
    weak var parent: TreeNode<Element>? = nil
    var children: [TreeNode<Element>] = []
    var element: Element
    
    init(parent: TreeNode<Element>? = nil, children: [TreeNode<Element>] = [], element: Element) {
        self.parent = parent
        self.children = children
        self.element = element
    }
}

// @dynamicMemberLookup
extension TreeNode {
    
    subscript<TargetValue>(dynamicMember keyPath: KeyPath<Element, TargetValue>) -> TargetValue {
        element[keyPath: keyPath]
    }
    
    subscript<TargetValue>(dynamicMember keyPath: WritableKeyPath<Element, TargetValue>) -> TargetValue {
        get {
            element[keyPath: keyPath]
        }
        set {
            element[keyPath: keyPath] = newValue
        }
    }
}
