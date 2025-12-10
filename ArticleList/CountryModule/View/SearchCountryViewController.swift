//
//  AddArticleViewController.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/17/25.
//

import UIKit

class SearchCountryViewController: UIViewController {
    
    //MARK: Properties
    
    private var retryCount = 0
    private let maxRetries = 3
    
    let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Country"
        titleLabel.textColor = .systemBlue
        titleLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 35)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Countries"
        searchBar.sizeToFit()
        return searchBar
    }()
    
    let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountryTableCell.self, forCellReuseIdentifier: CountryTableCell.reuseIdentifier)
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
    
    var countryViewModel: CountryViewModelProtocol
    
    init(viewModel: CountryViewModelProtocol) {
        countryViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        fetchArticles()
    }
}

//MARK: TableView DataSource Methods

extension SearchCountryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryViewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableCell.reuseIdentifier, for: indexPath) as? CountryTableCell else {
            return UITableViewCell()
        }
        cell.loadCellData(country: countryViewModel.getCountry(at: indexPath.row))
        return cell
    }
}

//MARK: Search Delegate Methods

extension SearchCountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        self.countryViewModel.applyFilter(text)
        self.tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        countryViewModel.applyFilter("")
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        countryViewModel.applyFilter(text)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

//MARK: Helper functions

extension SearchCountryViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
        tableView.tableHeaderView = searchBar
        
        tableView.refreshControl = refreshControl
        tableView.alwaysBounceVertical = true
    
        let vStack = UIStackView(arrangedSubviews: [titleLabel, tableView])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.heightAnchor.constraint(equalToConstant: 660)
        ])
    }
    
    func setupDelegates() {
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    @MainActor
    private func fetchArticles(isRefreshing: Bool = false) {
        Task {
            let errorState = await countryViewModel.getDataFromServer()
            
            if isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if let _ = errorState {
                if self.retryCount < self.maxRetries {
                    self.showRetryAlert(
                        title: "Hacker News",
                        message: self.countryViewModel.errorMessage
                    ) {
                        self.retryCount += 1
                        self.fetchArticles()
                    }
                } else {
                    self.showAlert(title: "Hacker News", message: self.countryViewModel.errorMessage)
                }
            } else {
                self.retryCount = 0
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func didPullToRefresh() {
           searchBar.text = nil
           countryViewModel.applyFilter("")
           fetchArticles(isRefreshing: true)
       }
}

