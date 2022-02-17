//
//  RepositorySearchPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
import UIKit

protocol RepositorySearchPresenterInput {
    var repositories: [Repository] { get }
    func viewDidLoad()
    func didSelectRowAt(_ indexPath: IndexPath)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
}

protocol RepositorySearchPresenterOutput: AnyObject {
    func didFetch(_ repositories: [Repository])
    func didFailToFetchRepository(with error: Error)
    func didFetchRepository(of repository: Repository)
}

class RepositorySearchPresenter: RepositorySearchPresenterInput {
    
    private(set) var repositories: [Repository] = [Repository]()
    
    private weak var repositorySearchView: RepositorySearchPresenterOutput?
    private var repositorySearchModel: GitHubAPIModelInput
    
    init(with view: RepositorySearchPresenterOutput) {
        self.repositorySearchView = view
        self.repositorySearchModel = GitHubAPIModel()
    }
    
    func viewDidLoad() {
        
    }
    
    private func getRepository(forRow row: Int) -> Repository? {
        if row < repositories.count { return repositories[row] }
        else { return nil }
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        guard let repository = getRepository(forRow: indexPath.row) else { return }
        repositorySearchView?.didFetchRepository(of: repository)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text, !searchWord.isEmpty else { return }
        repositorySearchModel.fetchRepositories(searchWord: searchWord, completion: { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.repositorySearchView?.didFetch(repositories)
            case .failure(let error):
                self?.repositorySearchView?.didFailToFetchRepository(with: error)
            }
        })
    }
}