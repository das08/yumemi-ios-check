//
//  GithubAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case invalidJSON
    case network
    case unexpected(String)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "正しいJSONではありません"
        case .network:
            return "サーバーと通信できません。"
        case .unexpected(let errorMsg):
            return errorMsg
        }
    }
}
