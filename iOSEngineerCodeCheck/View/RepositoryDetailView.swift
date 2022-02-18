//
//  RepositoryDetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailView: UIViewController {
    
    @IBOutlet weak var repoImageView: UIImageView!
    
    @IBOutlet weak var repoNameLabel: UILabel!
    
    @IBOutlet weak var repoLanguageLabel: UILabel!
    
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoWatchesLabel: UILabel!
    @IBOutlet weak var repoForksLabel: UILabel!
    @IBOutlet weak var repoIssuesLabel: UILabel!
    
    var searchViewController: SearchViewController?
    var repositorySearchView: RepositorySearchView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let selectedRowIdx = searchViewController?.selectedRowIdx,
            let repository = searchViewController?.repositories[selectedRowIdx]
        else { return }
        repoLanguageLabel.text = "Written in \(repository.getLanguage())"
        repoStarsLabel.text = "\(repository.starCount) stars"
        repoWatchesLabel.text = "\(repository.watchersCount) watchers"
        repoForksLabel.text = "\(repository.forksCount) forks"
        repoIssuesLabel.text = "\(repository.openIssuesCount) open issues"
        repoNameLabel.text = repository.fullName
//        getImage(repository: repository)
    }
}

