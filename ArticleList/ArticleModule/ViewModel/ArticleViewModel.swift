//
//  ArticleViewModel.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/9/25.
//
import Foundation

@MainActor
protocol ArticleViewModelProtocol {
    var articleList: [ArticleDetails] { get set}
    var visibleList: [ArticleDetails] { get set}
    var errorMessage: String { get }
    func getNumberOfRows() -> Int
    func getArticle(at index: Int) -> ArticleDetails
    func getDataFromServer() async -> NetworkState?
    func applyFilter(_ text: String)
    func updateArticleList(row: Int, updatedArticle: ArticleDetails)
    func deleteArticle(at index: Int)
}

class ArticleViewModel: ArticleViewModelProtocol{
    
    var articleList: [ArticleDetails] = []
    var visibleList: [ArticleDetails] = []
    private let networkManager: NetworkManagerProtocol
    var errorState: NetworkState?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getNumberOfRows() -> Int {
        return visibleList.count
    }
    
    func getArticle(at index: Int) -> ArticleDetails {
        return visibleList[index]
    }
        
    func getDataFromServer() async -> NetworkState? {
        let fetchedState = await networkManager.getData(from: Server.endPoint.rawValue)
        
        switch fetchedState {
        case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
            errorState = fetchedState
        case .success(let fetchedData):
            self.articleList = networkManager.parse(data: fetchedData)
            self.visibleList = articleList
            errorState = nil
        }
        return self.errorState
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
    
    func updateArticleList(row: Int, updatedArticle: ArticleDetails) {
        articleList[row] = updatedArticle
        visibleList[row] = updatedArticle
    }
    
    func deleteArticle(at index: Int) {
        guard (index < visibleList.count && index >= 0) else { return }
               let deletedArticle = visibleList.remove(at: index)
               if let index = articleList.firstIndex(where: { $0.author == deletedArticle.author }) {
                   articleList.remove(at: index)
               }
    }
}

extension ArticleViewModel {
    var errorMessage: String {
        guard let errorState = errorState else { return "" }
        switch errorState {
        case .invalidURL:
            return "Invalid URL"
        case .errorFetchingData:
            return "Error fetching data"
        case .noDataFromServer:
            return "No data from server"
        default :
            return ""
        }
    }
}

