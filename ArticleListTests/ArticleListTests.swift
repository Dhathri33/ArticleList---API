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
        
    }
    
    override func tearDownWithError() throws {
        
        articleViewModel = nil
        
    }
    
    func testGetNumberOfRows() {
        XCTAssertEqual(articleViewModel.getNumberOfRows(), 0)
    }
}

