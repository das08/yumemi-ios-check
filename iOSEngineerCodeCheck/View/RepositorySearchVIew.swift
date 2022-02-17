//
//  RepositorySearchVIew.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController2: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var presenter: RepositorySearchPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        presenter = RepositorySearchPresenter.init(with: self)
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController
            repositoryDetailViewController?.searchViewController2 = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        let repository = presenter.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.getLanguage()
        cell.tag = indexPath.row
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        presenter.didSelectRowAt(indexPath)
    }
}

extension SearchViewController2: RepositorySearchPresenterOutput {

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

extension SearchViewController2: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarSearchButtonClicked(searchBar)
        
    }
}
