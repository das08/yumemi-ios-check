//
//  RepositoryDetailModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RepositoryDetailModelInput {
    func getImage(repository: Repository, completion: @escaping ((Result<UIImage, Error>) -> ()))
}

class RepositoryDetailModel: RepositoryDetailModelInput {
    func getImage(repository: Repository, completion: @escaping ((Result<UIImage, Error>) -> ())) {
        guard
            let repoOwnerAvatar = repository.owner.avatarURL,
            let repoOwnerImageURL = URL(string: repoOwnerAvatar)
        else { return }
        
        URLSession.shared.dataTask(with: repoOwnerImageURL) { [weak self] (data, res, err) in
            // TODO: Display placeholder image if the image does not exist
            guard let repoOwnerImage = data, let img = UIImage(data: repoOwnerImage)
            else {
                completion(.failure(err as! Error))
                return
            }
            completion(.success(img))
        }.resume()
    }
}
