//
//  ArticleDetails.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

struct ArticleDetails: Decodable {
    let author: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    var comments: String?
    
    var publishedDateOnly: String {
        guard let publishedAt = publishedAt, publishedAt.count >= 10 else { return "" }
        return String(publishedAt.prefix(10))
    }
}

struct ArticleList: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDetails]
}
