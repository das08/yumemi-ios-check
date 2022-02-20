//
//  RepositorySearchModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Alamofire

protocol GitHubAPIModelInput {
    func fetchRepositories(searchWord: String, completion: @escaping ((Result<[Repository], Error>) -> Void))
}

class GitHubAPIModel: GitHubAPIModelInput {
    func fetchRepositories(searchWord: String, completion: @escaping ((Result<[Repository], Error>) -> Void)) {
        guard
            let urlString = "https://api.github.com/search/repositories?q=\(searchWord)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let apiEndpoint = URL(string: urlString)
        else { return }
        
        AF.request(apiEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate(statusCode: [200])
            .responseData { (response) in
                do{
                    switch response.result {
                    case .success(let data):
                        let searchResult = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                        completion(.success(searchResult.items))
                        
                    case .failure(let error):
                        throw error
                    }
                } catch {
                    if error as? APIError == APIError.network {
                        print("network Error")
                    } else {
                        print(error)
                    }
                    completion(.failure(error))
                }
            }
    }
}
