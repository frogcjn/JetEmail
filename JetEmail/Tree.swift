//
//  Tree.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

class Tree<Value> {
    var root: TreeNode<Value>
    
    init(rootValue: Value) {
        self.root = TreeNode(value: rootValue)
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
            print(queue)
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
    
    init(parent: TreeNode<Element>? = nil, children: [TreeNode<Element>] = [], value: Element) {
        self.parent = parent
        self.children = children
        self.element = value
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
