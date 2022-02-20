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
        
        AF.request(apiEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, requestModifier: { $0.timeoutInterval = 5.0 })
            .validate(statusCode: [200])
            .responseData { (response) in
                do {
                    switch response.result {
                    case .success(let data):
                        let searchResult = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                        if searchResult.items.isEmpty { completion(.failure(APIError.noMatchResult)) }
                        completion(.success(searchResult.items))
                        
                    case .failure(let error):
                        throw error
                    }
                } catch {
                    completion(.failure(self.localizedError(error: error)))
                }
            }
    }
    
    private func localizedError(error: Error) -> Error {
        let localizedError: Error
        switch error {
        case AFError.responseValidationFailed:
            localizedError = APIError.tooManyCall
            
        case APIError.network:
            localizedError = APIError.network
            
        case AFError.sessionTaskFailed(URLError.timedOut):
            localizedError = APIError.network
            
        default:
            localizedError = APIError.unexpected(error.localizedDescription)
        }
        return localizedError
    }
}
