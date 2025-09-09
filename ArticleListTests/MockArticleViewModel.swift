//
//  MockArticleViewModel.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/9/25.
//
@testable import ArticleList

class MockArticleViewModel: ArticleViewModelProtocol{

    var articleList: [ArticleDetails] = []
    
    var visibleList: [ArticleDetails] = []
    
    func getNumberOfRows() -> Int {
        articleList.count
    }
    
    func getArticle(at index: Int) -> ArticleDetails {
        if articleList.count > index {
            return articleList[index]
        }
        return ArticleDetails(author: "Dhathri" , description: "She is a working professional", urlToImage: "image", publishedAt: "today")
    }
    
    func getDataFromServer(completion: (() -> Void)?) {
        articleList = []
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
