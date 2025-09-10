//
//  ViewController.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

import UIKit

class ArticleViewController: UIViewController {
    
    //MARK: Properties

    let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "News"
        titleLabel.textColor = .systemBlue
        titleLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 35)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search News"
        searchBar.sizeToFit()
        return searchBar
    }()
    
    let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableCell.self, forCellReuseIdentifier: ArticleTableCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        return tableView
    }()
    
    var articleViewModel: ArticleViewModelProtocol!

    init(viewModel: ArticleViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        articleViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

extension ArticleViewController: UITableViewDataSource{
    
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

//MARK: TableView Delegate Methods

extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articleViewModel.getArticle(at: indexPath.row)
        let detailsVC = DetailsViewController()
        detailsVC.article = selectedArticle
        detailsVC.closure = { [weak self] updatedArticle in
            guard let self = self, let updatedArticle = updatedArticle else { return }
            self.articleViewModel.updateArticleList(row: indexPath.row, updatedArticle: updatedArticle)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

//MARK: Search Delegate Methods

extension ArticleViewController: UISearchBarDelegate {
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

extension ArticleViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
        tableView.tableHeaderView = searchBar
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, tableView])
        vStack.axis = .vertical
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.heightAnchor.constraint(equalToConstant: 680),
            tableView.widthAnchor.constraint(equalToConstant: 393)
        ])
    }
    
    func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
}
