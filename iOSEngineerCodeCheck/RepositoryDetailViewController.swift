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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let selectedRowIdx = searchViewController?.selectedRowIdx,
            let repository = searchViewController?.repositories[selectedRowIdx]
        else { return }
        repoLanguageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        repoStarsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        repoWatchesLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        repoForksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        repoIssuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage(repository: repository)
    }
    
    func getImage(repository: [String: Any]){
        repoNameLabel.text = repository["full_name"] as? String
        
        guard let repoOwner = repository["owner"] as? [String: Any] else { return }
        guard
            let repoOwnerAvatar = repoOwner["avatar_url"] as? String,
            let repoOwnerImageURL = URL(string: repoOwnerAvatar)
        else { return }
        
        URLSession.shared.dataTask(with: repoOwnerImageURL) { (data, res, err) in
            guard let repoOwnerImage = data, let img = UIImage(data: repoOwnerImage) else { return }
            DispatchQueue.main.async {
                self.repoImageView.image = img
            }
        }.resume()
    }
}
