//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/25/24.
//

import  class Foundation.NSRegularExpression
import struct Foundation.NSRange
import  class Foundation.NSAttributedString

// MARK: - String remove Encoding

public extension String {
    var isHTMLString: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "<[a-z][\\s\\S]*>", options: .caseInsensitive)
            let range = NSRange(startIndex..., in: self)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            return false
        }
    }

    var removingHTMLTags: String {
        if isHTMLString {
            replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        } else {
            self
        }
    }
}
/*
#if os(macOS)
import AppKit
#else
import UIKit
#endif
*/
public extension String {
    var removingHTMLEntities: String {
        let encodedString = self
        guard let data = encodedString.data(using: .utf8) else {
            return encodedString
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return encodedString
        }
    }
}
