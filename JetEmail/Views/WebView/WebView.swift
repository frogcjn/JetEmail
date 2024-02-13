//
//  WebView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/6/24.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    
    @Environment(AppSettings.self)
    var appSettings
    
    let htmlString: String
    
    func makeNSView(context: Context) -> WKWebView  {
        WKWebView()
    }
    
    func updateNSView(_ wkWebView: WKWebView, context: Context) {
        wkWebView.configuration.userContentController.removeAllUserScripts()
        wkWebView.loadHTMLString(htmlString, baseURL: nil)
        /*
        // add light dark mode
        let cssString = ":root { color-scheme: light dark; }"
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        wkWebView.evaluateJavaScript(jsString)*/
        
        if appSettings.isShowingWithDarkBackground {
            let lightDarkCSS = ":root { color-scheme: light dark; }"
            let base64 = lightDarkCSS.data(using: .utf8)!.base64EncodedString()
            
            let script = """
            javascript:(function() {
                var parent = document.getElementsByTagName('head').item(0);
                var style = document.createElement('style');
                style.type = 'text/css';
                style.innerHTML = window.atob('\(base64)');
                parent.appendChild(style);
            })()
        """
            
            
            let cssScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            wkWebView.configuration.userContentController.addUserScript(cssScript)
        }
    }
}
