//
//  NetworkState.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/15/25.
//

import Foundation

enum NetworkState {
    case isLoading
    case invalidURL
    case errorFetchingData
    case noDataFromServer
    case success(Data)
}
