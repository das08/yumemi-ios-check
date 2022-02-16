//
//  RepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

struct RepositorySearchResult: Codable {
    let items: [Repository]
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct Repository: Codable {
    let id: Int
    let fullName: String
    let owner: RepositoryOwner
    let language: String
    let starCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case language
        case starCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

struct RepositoryOwner: Codable {
    let id: Int
    let avatarURL: String?
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
    }
}

