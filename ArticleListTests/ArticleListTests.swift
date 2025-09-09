//
//  ArticleListTests.swift
//  ArticleListTests
//
//  Created by Dhathri Bathini on 9/8/25.
//

import XCTest
@testable import ArticleList

final class ArticleListTests: XCTestCase {
    
    var articleViewModel: ArticleViewModel!
    
    override func setUpWithError() throws {
        
        articleViewModel = ArticleViewModel()
        articleViewModel.sampleData()
        
    }
    
    override func tearDownWithError() throws {
        
        articleViewModel = nil
        
    }
    
    func testGetNumberOfRows() {
        
        XCTAssertEqual(articleViewModel.getNumberOfRows(), 1)
        
    }
    
    func testSampleData() {
        
        XCTAssertNotNil(articleViewModel.getArticle(at: 0))
        XCTAssertEqual(articleViewModel.getArticle(at: 0).author, "Dhathri")
        XCTAssertEqual(articleViewModel.getArticle(at: 0).urlToImage, "image")
        XCTAssertEqual(articleViewModel.getArticle(at: 0).publishedAt, "today")

    }
}

