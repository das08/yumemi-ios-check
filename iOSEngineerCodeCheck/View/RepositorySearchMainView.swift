//
//  RepositorySearchMainView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositorySearchMainView: UITableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var presenter: RepositorySearchPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        navigationBar.title = "Discover!"
        navigationBar.backBarButtonItem?.title = nil
        presenter = RepositorySearchPresenter.init(with: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let repositoryDetailViewController = segue.destination as? RepositoryDetailView,
            segue.identifier == "Detail"
        else { return }
        DispatchQueue.main.async{
            self.presenter.passRepository(to: repositoryDetailViewController)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        let repository = presenter.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        let cellDetailLabel = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "star")!))
        cellDetailLabel.append(NSAttributedString(string: String(repository.starCount)))
        cell.detailTextLabel?.attributedText = cellDetailLabel
        cell.tag = indexPath.row
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        presenter.didSelectRowAt(indexPath)
    }
}

extension RepositorySearchMainView: RepositorySearchPresenterOutput {
    func didFetch(_ repositories: [Repository]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didFailToFetchRepository(with error: Error) {
        print("error: didFailToFetchRepository")
    }

    func didFetchRepository(of repository: Repository) {
        print("success: didFetchRepository")
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

extension RepositorySearchMainView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text, !searchWord.isEmpty else { return }
        presenter.searchBarSearchButtonClicked(searchWord: searchWord)
        
    }
}
