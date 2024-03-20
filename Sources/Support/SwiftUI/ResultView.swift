//
//  ResultView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI

struct ResultView<Success, Failure: Error, SuccessContent: View, FailureContent: View> : View {
    let result: Result<Success, Failure>?
    
    @ViewBuilder
    let success: (Success) -> SuccessContent
    
    @ViewBuilder
    let failure: (Failure) -> FailureContent
    
    var body: some View {
        if let result {
            switch result {
            case .success(let success):
                self.success(success)
            case .failure(let failure):
                self.failure(failure)
            }
        }
    }
}

extension ResultView where FailureContent == ErrorText {
    init(_ result: Result<Success, Failure>?, @ViewBuilder sucesss:@escaping (Success) -> SuccessContent) {
        self.result = result
        self.success = sucesss
        self.failure = { error in ErrorText(String(describing: error)) }
    }
}


struct ErrorText : View {
    let text: any StringProtocol
    init(_ text: any StringProtocol) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(.red)
            .textSelection(.enabled)
    }
}
