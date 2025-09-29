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
    var errorMessage: String { get }
    func getNumberOfRows() -> Int
    func getArticle(at index: Int) -> ArticleDetails
    func getDataFromServer(completion: ((NetworkState?) -> Void)?)
    func applyFilter(_ text: String)
    func updateArticleList(row: Int, updatedArticle: ArticleDetails)
    func deleteArticle(at index: Int)
    func sathvikaSumFunction()
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
        
    func getDataFromServer(completion: ((NetworkState?) -> Void)?) {
        networkManager.getData(from: Server.endPoint.rawValue) { [weak self] fetchedState in
            guard let self = self else { return }
            
            switch fetchedState {
            case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
                errorState = fetchedState
                break
            case .success(let fetchedData):
                self.articleList = networkManager.parse(data: fetchedData)
                self.visibleList = articleList
                break
            }
            
            DispatchQueue.main.async {
                completion?(self.errorState)
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
    
    func sathvikaSumFunction() {
        let numAr = [1,2,3,4,5]
        let sum = numAr.filter{ $0 % 2 == 0}.reduce(0, +)
        print(sum)
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

