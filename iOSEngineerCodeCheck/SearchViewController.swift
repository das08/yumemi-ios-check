//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories: [[String: Any]]=[]
    
    var urlSessionTask: URLSessionTask?
    var selectedRowIdx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        urlSessionTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text, !searchWord.isEmpty else { return }
        // TODO: Sanitize query params
        guard let apiEndpoint = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else { return }
        
        urlSessionTask = URLSession.shared.dataTask(with: apiEndpoint) { (data, res, err) in
            guard let data = data,
                  err == nil,
                  let apiResponse = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                  let repositories = apiResponse["items"] as? [[String: Any]]
            else { return }
            self.repositories = repositories
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // これ呼ばなきゃリストが更新されません
        urlSessionTask?.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let repositoryDetailViewController = segue.destination as! RepositoryDetailViewController
            repositoryDetailViewController.searchViewController = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        selectedRowIdx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
