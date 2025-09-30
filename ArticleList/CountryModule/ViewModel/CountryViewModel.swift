//
//  CountryViewModel.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/18/25.
//

import Foundation

@MainActor
protocol CountryViewModelProtocol {
    var countryList: [Country] { get set}
    var visibleList: [Country] { get set}
    var errorMessage: String { get }
    func getNumberOfRows() -> Int
    func getCountry(at index: Int) -> Country
    func getDataFromServer() async -> NetworkState?
    func applyFilter(_ text: String)
}

class CountryViewModel: CountryViewModelProtocol {
    
    var countryList: [Country] = []
    var visibleList: [Country] = []
    private let networkManager: NetworkManagerProtocol
    var errorState: NetworkState?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getNumberOfRows() -> Int {
        return visibleList.count
    }
    
    func getCountry(at index: Int) -> Country {
        return visibleList[index]
    }
    
    func getDataFromServer() async -> NetworkState? {
        let fetchedState = await networkManager.getData(from: Server.endPointCountry.rawValue)
        
        switch fetchedState {
        case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
            errorState = fetchedState
        case .success(let fetchedData):
            self.countryList = networkManager.parseCountry(data: fetchedData)
            self.visibleList = countryList
            errorState = nil
        }
        return self.errorState
    }
    
    func applyFilter(_ text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { visibleList = countryList; return }
        let q = query.lowercased()
        visibleList = countryList.filter {
            $0.name.lowercased().contains(q) || $0.capital.lowercased().contains(q)
        }
    }
}

extension CountryViewModel {
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

