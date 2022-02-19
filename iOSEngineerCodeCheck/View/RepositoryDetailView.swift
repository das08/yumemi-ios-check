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
    @IBOutlet weak var repoLanguageColor: UIImageView!
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoWatchesLabel: UILabel!
    @IBOutlet weak var repoForksLabel: UILabel!
    @IBOutlet weak var repoIssuesLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBAction func openRepositoryButton(_ sender: UIButton) {
        openRepository()
    }
    @IBAction func shareRepositoryButton(_ sender: UIButton) {
        shareRepository()
    }
    
    private var repositoryURL: String?
    private var presenter: RepositoryDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RepositoryDetailPresenter.init(with: self)
        prepareLabels()
    }
}

extension RepositoryDetailView {
    private func prepareLabels() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        starIconImage.image = Image(systemName: "star")
        watcherIconImage.image = Image(systemName: "eye")
        forkIconImage.image = Image(systemName: "arrow.triangle.branch")
        issueIconImage.image = Image(systemName: "dot.circle")
        navigationBar.rightBarButtonItem = UIBarButtonItem(image: Image(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareRepositoryButton))
    }
    
    private func setRepositoryDetail(repository: Repository) {
        repoStarsLabel.text = String(repository.starCount)
        repoWatchesLabel.text = String(repository.watchersCount)
        repoForksLabel.text = String(repository.forksCount)
        repoIssuesLabel.text = String(repository.openIssuesCount)
        repoNameLabel.text = repository.fullName
        navigationBar.title = repository.fullName
        repositoryURL = repository.url
        prepareLanguageColor(repository: repository)
    }
    
    private func prepareLanguageColor(repository: Repository) {
        let languageColor = LoadLanguageColor.shared.getColorOf(lang: repository.getLanguage())
        guard let colorHex = languageColor?.hex else { return }
        repoLanguageColor.image = Image(systemName: "circle.fill")
        repoLanguageColor.tintColor = UIColor(hex: colorHex)
        repoLanguageLabel.text = repository.getLanguage()
    }
    
    private func openRepository() {
        guard let repoURL = repositoryURL, let url = URL(string: repoURL)
        else { return }
        UIApplication.shared.open(url)
    }
    
    private func shareRepository() {
        guard let repoURL = repositoryURL, let url = URL(string: repoURL)
        else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
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
