//
//  RepositorySearchVIew.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController2: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories: [Repository]=[]
    
    var selectedRowIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController
            repositoryDetailViewController?.searchViewController2 = self
        }
    }
}

//extension SearchViewController2

extension SearchViewController2: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.getLanguage()
        cell.tag = indexPath.row
        
        return cell
    }
}

extension SearchViewController2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        selectedRowIdx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

extension SearchViewController2: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
}
