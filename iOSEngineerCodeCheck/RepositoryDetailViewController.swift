//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
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
        getImage(repository: repository)
    }
    
    func getImage(repository: Repository){
        guard
            let repoOwnerAvatar = repository.owner.avatarURL,
            let repoOwnerImageURL = URL(string: repoOwnerAvatar)
        else { return }
        
        URLSession.shared.dataTask(with: repoOwnerImageURL) { [weak self] (data, res, err) in
            // TODO: Display placeholder image if the image does not exist
            guard let repoOwnerImage = data, let img = UIImage(data: repoOwnerImage) else { return }
            DispatchQueue.main.async {
                self?.repoImageView.image = img
            }
        }.resume()
    }
}
