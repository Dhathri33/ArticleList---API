//
//  NetworkManager.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getArticles(from serverUrl: String, closure: @escaping ([ArticleDetails]) -> Void) {
        guard let serverURL = URL(string: serverUrl) else {
            print("Server URL is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: serverURL) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from the server")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ArticleList.self, from: data)
                closure(decodedResponse.articles)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}
