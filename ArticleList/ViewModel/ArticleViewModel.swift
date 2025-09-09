//
//  ArticleViewModel.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/9/25.
//
import Foundation

protocol ArticleViewModelProtocol {
    var articleList: [ArticleDetails] { get set}
    var visibleList: [ArticleDetails] { get set}
    func getNumberOfRows() -> Int
    func getArticle(at index: Int) -> ArticleDetails
    func getDataFromServer(completion: (() -> Void)?)
}

class ArticleViewModel: ArticleViewModelProtocol{
    
    var articleList: [ArticleDetails] = []
    var visibleList: [ArticleDetails] = []
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getNumberOfRows() -> Int {
        return visibleList.count
    }
    
    func getArticle(at index: Int) -> ArticleDetails {
        return visibleList[index]
    }
        
    func getDataFromServer(completion: (() -> Void)?) {
        networkManager.getArticles(from: Server.endPoint.rawValue) { [weak self] fetchedList in
            guard let self = self else { return }
            self.articleList = fetchedList
            self.visibleList = articleList
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    func applyFilter(_ text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            visibleList = articleList
            return
        }
        visibleList = articleList.filter {
            $0.author?.lowercased().range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil || $0.description?.lowercased().range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
    }
}

