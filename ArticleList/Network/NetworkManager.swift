//
//  NetworkManager.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func getData(from serverUrl: String?, closure: @escaping (NetworkState) -> Void)
    func parse(data: Data?) -> [ArticleDetails]
    func parseCountry(data: Data?) -> [Country]
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    var state: NetworkState = .isLoading
    
    func getData(from serverUrl: String?, closure: @escaping (NetworkState) -> Void) {
        guard let imageUrl = serverUrl, let serverURL = URL(string: imageUrl) else {
            state = .invalidURL
            closure(state)
            return
        }
        
        URLSession.shared.dataTask(with: serverURL) { data, response, error in
            if let _ = error {
                self.state = .errorFetchingData
                closure(self.state)
                return
            }
            
            guard let data else {
                self.state = .noDataFromServer
                closure(self.state)
                return
            }
            self.state = .success(data)
            closure(self.state)
        }.resume()
    }
    
    func parse(data: Data?) -> [ArticleDetails] {
        guard let data = data else {
            print("No data to parse")
            return []
        }
        do {
            let decoder = JSONDecoder()
            let fetchedResult = try decoder.decode(ArticleList.self, from: data)
            return fetchedResult.articles
        } catch {
            print(error)
        }
        return []
    }
    
    func parseCountry(data: Data?) -> [Country] {
        guard let data = data else {
            print("No data to parse")
            return []
        }
        do {
            let decoder = JSONDecoder()
            let fetchedResult = try decoder.decode([Country].self, from: data)
            return fetchedResult
        } catch {
            print(error)
        }
        return []
    }
}
