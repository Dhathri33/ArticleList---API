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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemBlue
        return activityIndicator
    }()
    
    var articleViewModel: ArticleViewModelProtocol!
    var coordinatorFlowDelegate: ArticleListCoordinatorProtocol?
    private var searchDebounce: DispatchWorkItem?
    private let debounceInterval: TimeInterval = 1.0 // 1s;

    deinit {
        searchDebounce?.cancel()
    }

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
        fetchArticles()
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
        
        let selected = articleViewModel.getArticle(at: indexPath.row)
        let image = (tableView.cellForRow(at: indexPath) as? ArticleTableCell)?.articleImageView.image
        let closure: ((ArticleDetails?) -> Void?) = { [weak self] updated in
            guard let self = self, let updated = updated else { return }
            self.articleViewModel.updateArticleList(row: indexPath.row, updatedArticle: updated)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }

        coordinatorFlowDelegate?.showDetailScreen(
            article: selected,
            prefetchedImage: image,
            onSave: closure)
    }
}

//MARK: Search Delegate Methods

extension ArticleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDebounce?.cancel()
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.articleViewModel.applyFilter(text)
            self.tableView.reloadData()
        }
        searchDebounce = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDebounce?.cancel()
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        articleViewModel.applyFilter("")
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchDebounce?.cancel()
        let text = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        articleViewModel.applyFilter(text)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

//MARK: Helper functions

extension ArticleViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
        tableView.tableHeaderView = searchBar
        
        tableView.refreshControl = refreshControl
        tableView.alwaysBounceVertical = true
        tableView.addSubview(activityIndicator)
        tableView.bringSubviewToFront(activityIndicator)
        
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, tableView])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 600),
            tableView.widthAnchor.constraint(equalToConstant: 393),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    private func fetchArticles(isRefreshing: Bool = false) {
        if !isRefreshing {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
        }
        articleViewModel.getDataFromServer { [weak self] errorState in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                if isRefreshing {
                    self.refreshControl.endRefreshing()
                } else {
                    self.activityIndicator.stopAnimating()
                }
                if let _ = errorState {
                    self.showAlert(title: "Hacker News", message: self.articleViewModel.errorMessage)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    @objc private func didPullToRefresh() {
           searchBar.text = nil
           articleViewModel.applyFilter("")
           fetchArticles(isRefreshing: true)
       }
}
