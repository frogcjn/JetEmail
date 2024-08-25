//
//  GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//
import AppAuth
import GTMAppAuth
import typealias JetEmailFoundation.CodableValueType
import  protocol JetEmailFoundation.ValueType

import JetEmailData

public actor GoogleClient {
    
    @MainActor
    public static let shared = GoogleClient()
    
    let      clientID                  =             "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
    let   redirectURL                  = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
    let        scopes: [String]        = [
        // Google 会将您的姓名、电子邮件地址、语言偏好设置和个人资料照片分享给Jet Email
        GoogleScope.openid.rawValue,  // 将您与您在 Google 上的个人信息关联起来
        GoogleScope.email.rawValue,   // 查看您 Google 帐号的主电子邮件地址
        GoogleScope.profile.rawValue, // 查看您的个人信息，包括您已公开的任何个人信息
        
        GmailScope.all.rawValue,      // 阅读、撰写、发送及永久删除您的全部 Gmail 电子邮件。
                
        /*
        GmailScope.readOnly,          // 查看您的电子邮件及设置
        GmailScope.metadata,          // 查看标签和标头等电子邮件的元数据（而非电子邮件正文）
        GmailScope.send,              // 代表您发送电子邮件                                  /* optional */
        GmailScope.labels,            // 查看和修改您的电子邮件标签。
        GmailScope.insert,            // 将电子邮件添加到您的 Gmail 邮箱。                     /* optional */
        GmailScope.gmailSettingsSharing,     // 管理您的敏感邮件设置，包括哪些人可以管理您的邮件?         /* optional */
        GmailScope.settingsBasic,     // 查看、修改、创建或更改您在 Gmail 中的电子邮件设置和过滤器
        GmailScope.compose,           // 管理草案和发送电子邮件                               /* optional */
        GmailScope.modify,            // 使用您的 Gmail 账号阅读、撰写和发送电子邮件。           /* optional */
        */
    ]
    
    let configuration                  = GTMSession.configurationForGoogle()
    let  responseType: ResponseType    = .code
    let kIncludeGrantedScopesParameter = "include_granted_scopes"
    init(){}
    
    var keychain: Keychain { .shared }
}

extension GoogleClient {
    
    protocol Scope : RawRepresentable where Self.RawValue == String {}
    
    // https://developers.google.com/gmail/api/auth/scopes
    enum GoogleScope: String, CodableValueType, Scope {
        case openid                                                                          // 将您与您在 Google 上的个人信息关联起来
        case email                = "https://www.googleapis.com/auth/userinfo.email"         // 查看您 Google 帐号的主电子邮件地址
        case profile              = "https://www.googleapis.com/auth/userinfo.profile"       // 查看您的个人信息，包括您已公开的任何个人信息
    }
    
    enum GmailScope: String, CodableValueType, Scope  {
        
        /* Gmail All*/
        case all             = "https://mail.google.com/"
        
        /* Gmail SubScopes*/
        case readOnly        = "https://www.googleapis.com/auth/gmail.readonly"         // 读取所有资源及其元数据，无写入操作。
        case metadata        = "https://www.googleapis.com/auth/gmail.metadata"         // 读取资源元数据，包括标签、历史记录和电子邮件标头，但不包括邮件正文或附件。
        case send            = "https://www.googleapis.com/auth/gmail.send"             // 仅发送信息。没有对邮箱的读取或修改权限。
        case labels          = "https://www.googleapis.com/auth/gmail.labels"           // 只能创建、读取、更新和删除标签。
        case insert          = "https://www.googleapis.com/auth/gmail.insert"           // 仅插入和导入邮件。
        case settingsSharing = "https://www.googleapis.com/auth/gmail.settings.sharing" // 管理敏感邮件设置，包括转发规则和别名。注意：受此范围保护的操作仅限管理使用。此类功能仅适用于使用具有全网域授权功能的服务帐号的 Google Workspace 客户。
        case settingsBasic   = "https://www.googleapis.com/auth/gmail.settings.basic"   // 管理基本邮件设置。
        case compose         = "https://www.googleapis.com/auth/gmail.compose"          // 创建、读取、更新和删除草稿。发送邮件和草稿。
        case modify          = "https://www.googleapis.com/auth/gmail.modify"           // 除立即永久删除线程和消息外的所有读/写操作（绕过回收站）。

        /* Gmail Add-On */
        case gmailAddOnCompose    = "https://www.googleapis.com/auth/gmail.addons.current.action.compose"
        case gmailAddOnMessage    = "https://www.googleapis.com/auth/gmail.addons.current.message.action"
        case gmailAddOnMetadata   = "https://www.googleapis.com/auth/gmail.addons.current.message.metadata"
        case gmailAddOnReadOnly   = "https://www.googleapis.com/auth/gmail.addons.current.message.readonly"
    }
    
    enum ResponseType: String, CodableValueType {
        case code // OIDResponseTypeCode
    }
}

public typealias GTMSessionDelegate  = AuthSessionDelegate
public typealias GTMSession         = AuthSession
       typealias GTMConfiguration   = OIDServiceConfiguration

extension        GTMSession : @unchecked @retroactive Sendable {}
extension  GTMConfiguration : @unchecked @retroactive Sendable {}
