//
//  ArticleDetails.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//
@propertyWrapper
struct DateOnly: Decodable {
    private var value: String?
    //Used Property Observer
    var wrappedValue: String? {
        guard let value = value, value.count >= 10 else { return nil }
        return String(value.prefix(10))
    }
    
    init(wrappedValue: String?) {
        self.value = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try? container.decode(String.self)
    }
}

struct ArticleDetails: Decodable {
    var author: String?
    let description: String?
    let urlToImage: String?
    
    @DateOnly var publishedAt: String?
    
    var comments: String? {
        willSet {
            print("About to change comment from \(comments ?? "nil") to \(newValue ?? "nil")")
        }
        didSet {
            print("Changed comment from \(oldValue ?? "nil") to \(comments ?? "nil")")
        }
    }
}

struct ArticleList: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDetails]
}
