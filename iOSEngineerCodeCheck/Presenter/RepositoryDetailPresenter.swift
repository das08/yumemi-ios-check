//
//  RepositoryDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import AlamofireImage

protocol RepositoryDetailPresenterInput {
    func receive(_ repository: Repository)
}

protocol RepositoryDetailPresenterOutput: AnyObject {
    func didFetch(_ imageData: Image)
    func didFailToFetchImage(with error: Error)
}

class RepositoryDetailPresenter: RepositoryDetailPresenterInput {
    var selectedRepository: Repository?
    private var image: Image?

    private weak var repositoryDetailView: RepositoryDetailPresenterOutput?
    private var repositoryDetailModel: RepositoryDetailModelInput

    init(with view: RepositoryDetailPresenterOutput, with model: RepositoryDetailModel) {
        self.repositoryDetailView = view
        self.repositoryDetailModel = model
    }
}

extension RepositoryDetailPresenter: RepositoryReceiver {
    func receive(_ repository: Repository) {
        selectedRepository = repository
        guard let repository = selectedRepository else { return }
        repositoryDetailModel.getImage(repository: repository, completion: { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
                self?.repositoryDetailView?.didFetch(image)
            case .failure(let error):
                self?.repositoryDetailView?.didFailToFetchImage(with: error)
            }
        })
    }
}
