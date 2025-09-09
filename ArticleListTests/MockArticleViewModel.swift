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
    
}
