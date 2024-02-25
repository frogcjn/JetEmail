//
//  Message+Google.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import Foundation
import GoogleAPIClientForREST_Gmail
import MimeEmailParser

extension Message {
    var google: Google.Message.Full? {
        get {
            try? _google?.decodeJSON(Google.Message.Full.self)
        }
    }
    
    func setGoogle(_ google: Google.Message.Full) throws {
        if let internalDate = google.internalDate       { self.date        = internalDate.milliSecondsTimeIntervalSince1970 }
        if let snippet      = google.snippet            { self.bodyPreview = snippet                                        }
        if let raw          = google.raw                { self.raw         = raw                                            }
        
        if let headers = google.payload?.headers {
            /*
             header fields:
                subject
                from/sender/replyTo/to/cc/bcc
                messageID/inReplyTo/references
             */
            for header in headers {
                let name  = header.name
                let value = header.value
                
                switch name {
                    
                case HeaderFieldName.subject    : subject     = value
                    
                    // Originator Fields
                case HeaderFieldName.from       : from        = value
                case HeaderFieldName.sender     : sender      = value
                case HeaderFieldName.replyTo    : replyTo     = value
                    
                    // Destination Address Fields
                case HeaderFieldName.to         : to          = value
                case HeaderFieldName.cc         : cc          = value
                case HeaderFieldName.bcc        : bcc         = value
                case HeaderFieldName.deliveredTo: deliveredTo = value
                    
                default: break
                }
            }
        }
        
        if let body = try google.payload?.messageBody {
            self.body = body
        }
    }
}
