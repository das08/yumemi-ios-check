//
//  RepositoryDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol RepositoryDetailPresenterInput {
    func viewDidLoad()
    func receive(_ repository: Repository)
}

protocol RepositoryDetailPresenterOutput: AnyObject {
    func didFetch(_ imageData: Data)
    func didFailToFetchImage(with error: Error)
}

class RepositoryDetailPresenter: RepositoryDetailPresenterInput {
    var selectedRepository: Repository?
    private var imageData: Data?

    private weak var repositoryDetailView: RepositoryDetailPresenterOutput?
    private var repositoryDetailModel: RepositoryDetailModelInput

    init(with view: RepositoryDetailPresenterOutput) {
        self.repositoryDetailView = view
        self.repositoryDetailModel = RepositoryDetailModel()
    }

    func viewDidLoad() {
        
    }
}

extension RepositoryDetailPresenter: RepositoryReceiver {
    func receive(_ repository: Repository) {
        selectedRepository = repository
        guard let repository = selectedRepository else { return }
        repositoryDetailModel.getImage(repository: repository, completion: { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageData = imageData
                self?.repositoryDetailView?.didFetch(imageData)
            case .failure(let error):
                self?.repositoryDetailView?.didFailToFetchImage(with: error)
            }
        })
    }
}
