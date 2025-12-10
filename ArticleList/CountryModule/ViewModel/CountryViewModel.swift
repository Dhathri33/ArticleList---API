//
//  CountryViewModel.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/18/25.
//

import Foundation
import CoreData

@MainActor
protocol CountryViewModelProtocol {
    var countryList: [Country] { get set}
    var visibleList: [Country] { get set}
    var errorMessage: String { get }
    func getNumberOfRows() -> Int
    func getCountry(at index: Int) -> Country
    func getDataFromServer() async -> NetworkState?
    func applyFilter(_ text: String)
    func loadFromCache()
    func saveToCache(countries: [Country])
}

class CountryViewModel: CountryViewModelProtocol {
    
    var countryList: [Country] = []
    var visibleList: [Country] = []
    private let networkManager: NetworkManagerProtocol
    var errorState: NetworkState?
    private let context = CoreDataStack.shared.context
    
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
            saveToCache(countries: countryList)

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
    
    func saveToCache(countries: [Country]) {
        let fetch: NSFetchRequest<NSFetchRequestResult> = CountryCore.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: fetch)

        do {
            try context.execute(delete)
        } catch {
            print("Failed to clear old cache:", error)
        }

        for country in countries {
            CountryCore.fromModel(country, context: context)
        }

        do {
            try context.save()
        } catch {
            print("Failed to save cache:", error)
        }
    }
    
    func loadFromCache() {
        let request: NSFetchRequest<CountryCore> = CountryCore.fetchRequest()
        do {
            let stored = try context.fetch(request)
            let models = stored.map { $0.toModel() }
            self.countryList = models
            self.visibleList = models
        } catch {
            print("Failed to load cache:", error)
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

