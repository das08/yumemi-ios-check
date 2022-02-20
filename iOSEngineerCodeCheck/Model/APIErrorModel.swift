//
//  GithubAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public enum APIError: Error, Equatable {
    case invalidJSON
    case invalidSearchWord
    case network
    case tooManyCall
    case noMatchResult
    case unexpected(String)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "正しいJSONではありません。"
        
        case .invalidSearchWord:
            return "検索する単語を変えてお試しください。"
            
        case .network:
            return "ネットワークエラーです。時間を開けて再度お試しください。"
            
        case .tooManyCall:
            return "検索回数の上限に達しました。時間を開けて再度お試しください。"
            
        case .noMatchResult:
            return "お探しのレポジトリは見つかりませんでした。\n検索ワードを変えて再度お試しください。"
            
        case .unexpected(let errorMsg):
            return errorMsg
            
        }
    }
}
