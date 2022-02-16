//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories: [Repository]=[]
    
    var urlSessionTask: URLSessionTask?
    var selectedRowIdx: Int?
    
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
        // TODO: Separate functions
        // TODO: Sanitize query params
        guard let apiEndpoint = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)")
        else { return }
        
        AF.request(apiEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate(statusCode: [200])
            .responseData { [weak self] (response) in
                do{
                    switch response.result {
                    case .success(let data):
                        let searchResult = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                        self?.repositories = searchResult.items
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    case .failure(let error):
                        throw error
                    }
                } catch {
                    if error as? APIError == APIError.network{
                        print("network Error")
                    } else {
                        print(error)
                    }
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController
            repositoryDetailViewController?.searchViewController = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.getLanguage()
        cell.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        selectedRowIdx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
