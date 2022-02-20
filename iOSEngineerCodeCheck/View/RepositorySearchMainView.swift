//
//  RepositorySearchMainView.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RepositorySearchMainView: UITableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var presenter: RepositorySearchPresenter!
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareActivityIndicator()
        prepareBars()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let repositoryDetailViewController = segue.destination as? RepositoryDetailView,
            segue.identifier == "Detail"
        else { return }
        DispatchQueue.main.async {
            self.presenter.passRepository(to: repositoryDetailViewController)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        return createCellText(cell: cell, indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(row: indexPath.row)
    }
}

extension RepositorySearchMainView {
    private func prepareActivityIndicator() {
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballSpinFadeLoader, color: .gray, padding: 0)
        activityIndicatorView.center = self.view.center
        view.addSubview(activityIndicatorView)
    }
    
    private func prepareBars() {
        searchBar.delegate = self
        navigationBar.title = "Discover!"
        navigationBar.backBarButtonItem?.title = nil
        presenter = RepositorySearchPresenter.init(with: self, with: GitHubAPIModel())
    }
    
    private func createCellText(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        let repository = presenter.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        let cellDetailLabel = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "star")!))
        cellDetailLabel.append(NSAttributedString(string: String(repository.starCount)))
        cell.detailTextLabel?.attributedText = cellDetailLabel
        cell.tag = indexPath.row
        return cell
    }
}

extension RepositorySearchMainView: RepositorySearchPresenterOutput {
    func didStartToFetch() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func didFetch(_ repositories: [Repository]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }

    func didFailToFetchRepository(with error: Error) {
        print("error: didFailToFetchRepository")
        let alert = UIAlertController.createOKAlert(title: "取得エラー", message: error.localizedDescription, vc: self)
        present(alert, animated: true, completion: nil)
        self.activityIndicatorView.stopAnimating()
    }

    func didFetchRepository(of repository: Repository) {
        print("success: didFetchRepository")
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
    func didBeginEditing() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RepositorySearchMainView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextDidChange()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        guard let searchWord = searchBar.text, !searchWord.isEmpty else { return }
        presenter.searchBarSearchButtonClicked(searchWord: searchWord)
    }
}
