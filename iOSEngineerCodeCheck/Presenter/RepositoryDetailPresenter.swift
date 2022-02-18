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
    func didFetch(_ image: UIImage)
    func didFailToFetchImage(with error: Error)
}

class RepositoryDetailPresenter: RepositoryDetailPresenterInput {

    private(set) var imageData = Data(base64Encoded: "aa")
    var selectedRepository: Repository?

    private weak var repositoryDetailView: RepositoryDetailPresenterOutput?
    private var repositoryDetailModel: RepositoryDetailModelInput

    init(with view: RepositoryDetailPresenterOutput) {
        self.repositoryDetailView = view
        self.repositoryDetailModel = RepositoryDetailModel()
    }

    func viewDidLoad() {
        guard let repository = selectedRepository else { return }
        repositoryDetailModel.getImage(repository: repository, completion: { [weak self] result in
            switch result {
            case .success(let image):
//                self?.image = image
                self?.repositoryDetailView?.didFetch(image)
            case .failure(let error):
                self?.repositoryDetailView?.didFailToFetchImage(with: error)
            }
        })
    }
}

extension RepositoryDetailPresenter: RepositoryReceiver {
    func receive(_ repository: Repository) {
        selectedRepository = repository
    }
}
