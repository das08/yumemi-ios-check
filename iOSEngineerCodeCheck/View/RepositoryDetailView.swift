//
//  RepositoryDetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import AlamofireImage

class RepositoryDetailView: UIViewController {
    @IBOutlet weak var starIconImage: UIImageView!
    @IBOutlet weak var watcherIconImage: UIImageView!
    @IBOutlet weak var forkIconImage: UIImageView!
    @IBOutlet weak var issueIconImage: UIImageView!
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoWatchesLabel: UILabel!
    @IBOutlet weak var repoForksLabel: UILabel!
    @IBOutlet weak var repoIssuesLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    private var presenter: RepositoryDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RepositoryDetailPresenter.init(with: self)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        prepareLabels()
    }
    
    private func setRepositoryDetail(repository: Repository) {
        repoLanguageLabel.text = repository.getLanguage()
        repoStarsLabel.text = String(repository.starCount)
        repoWatchesLabel.text = String(repository.watchersCount)
        repoForksLabel.text = String(repository.forksCount)
        repoIssuesLabel.text = String(repository.openIssuesCount)
        repoNameLabel.text = repository.fullName
        navigationBar.title = repository.fullName
    }
    
    private func prepareLabels() {
        starIconImage.image = Image(systemName: "star")
        watcherIconImage.image = Image(systemName: "eye")
        forkIconImage.image = Image(systemName: "arrow.triangle.branch")
        issueIconImage.image = Image(systemName: "dot.circle")
    }
}

extension RepositoryDetailView: RepositoryDetailPresenterOutput {
    func didFetch(_ image: Image) {
        DispatchQueue.main.async {
            self.repoImageView.image = image
            self.repoImageView.makeRound()
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
