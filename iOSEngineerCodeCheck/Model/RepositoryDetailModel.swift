//
//  RepositoryDetailModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
import Foundation

protocol RepositoryDetailModelInput {
    func getImage(repository: Repository, completion: @escaping ((Result<Data, Error>) -> ()))
}

class RepositoryDetailModel: RepositoryDetailModelInput {
    func getImage(repository: Repository, completion: @escaping ((Result<Data, Error>) -> ())) {
        guard
            let repoOwnerAvatar = repository.owner.avatarURL,
            let repoOwnerImageURL = URL(string: repoOwnerAvatar)
        else { return }
        
        URLSession.shared.dataTask(with: repoOwnerImageURL) { [weak self] (data, res, err) in
            // TODO: Display placeholder image if the image does not exist
            guard let imageData = data
            else {
                completion(.failure(err as! Error))
                return
            }
            completion(.success(imageData))
        }.resume()
    }
}
