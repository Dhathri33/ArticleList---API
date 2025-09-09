//
//  ViewController.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    
    let tableView = UITableView()
    let titleLabel = UILabel()
    var searchBar = UISearchBar()
    var articleViewModel: ArticleViewModel = ArticleViewModel()

    //MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        articleViewModel.getDataFromServer { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleViewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableCell.reuseIdentifier, for: indexPath) as? ArticleTableCell else {
            return UITableViewCell()
        }
        cell.loadCellData(article: articleViewModel.getArticle(at: indexPath.row))
        return cell
    }
}

//MARK: Search Delegate Methods

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        articleViewModel.applyFilter(searchText)
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        articleViewModel.applyFilter("")
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: Helper functions

extension ViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        titleLabel.text = "News"
        titleLabel.textColor = .systemBlue
        titleLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 35)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = "Search News"
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableCell.self, forCellReuseIdentifier: ArticleTableCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, tableView])
        vStack.axis = .vertical
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableView.heightAnchor.constraint(equalToConstant: 680),
            tableView.widthAnchor.constraint(equalToConstant: 393)
        ])
    }
    
    func setupDelegates() {
        tableView.dataSource = self
        searchBar.delegate = self
    }
}
