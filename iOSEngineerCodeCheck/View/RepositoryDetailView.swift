//
//  RepositoryDetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import AlamofireImage

class RepositoryDetailView: UIViewController {
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoWatchesLabel: UILabel!
    @IBOutlet weak var repoForksLabel: UILabel!
    @IBOutlet weak var repoIssuesLabel: UILabel!
    
    private var presenter: RepositoryDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RepositoryDetailPresenter.init(with: self)
    }
    
    private func setRepositoryDetail(repository: Repository) {
        repoLanguageLabel.text = "Written in \(repository.getLanguage())"
        repoStarsLabel.text = "\(repository.starCount) stars"
        repoWatchesLabel.text = "\(repository.watchersCount) watchers"
        repoForksLabel.text = "\(repository.forksCount) forks"
        repoIssuesLabel.text = "\(repository.openIssuesCount) open issues"
        repoNameLabel.text = repository.fullName
    }
}

extension RepositoryDetailView: RepositoryDetailPresenterOutput {
    func didFetch(_ image: Image) {
        DispatchQueue.main.async {
            self.repoImageView.image = image
        }
    }
    
    func didFailToFetchImage(with error: Error) {
        print(2)
    }
}

extension RepositoryDetailView: RepositoryReceiver {
    func receive(_ repository: Repository) {
        presenter.receive(repository)
        setRepositoryDetail(repository: repository)
    }
}
