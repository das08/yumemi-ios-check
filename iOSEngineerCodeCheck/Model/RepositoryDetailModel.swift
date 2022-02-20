//
//  RepositoryDetailModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
import Alamofire
import AlamofireImage

protocol RepositoryDetailModelInput {
    func getImage(repository: Repository, completion: @escaping ((Result<Image, Error>) -> Void))
}

class RepositoryDetailModel: RepositoryDetailModelInput {
    func getImage(repository: Repository, completion: @escaping ((Result<Image, Error>) -> Void)) {
        guard
            let repoOwnerAvatar = repository.owner.avatarURL,
            let repoOwnerImageURL = URL(string: repoOwnerAvatar)
        else { return }
        
        AF.request(repoOwnerImageURL).responseImage { response in
            switch response.result {
            case .success(let image):
                completion(.success(image))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
