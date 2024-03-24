//
//  Message.Body.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

public struct MessageBody: CodableValueType, Sendable {
        public let text: String
        public let html: String?
        
    public init?(text: String? = nil, html: String? = nil) {
        switch (text, html) {
        case (let text?, let html?):
            self.text = text.removingHTMLTags
            self.html = html
        case (nil, let html?):
            self.text = html.removingHTMLTags
            self.html = html
        case (let text?, nil):
            self.text = text.removingHTMLTags
            self.html = nil
        case (nil, nil):
            return nil
        }
    }
}

