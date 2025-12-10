//
//  ConnectivityManager.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 12/10/25.
//
import Foundation
import Network

class ConnectivityManager {
    
    static let shared = ConnectivityManager()
    private var monitor: NWPathMonitor = NWPathMonitor()
    private var queue: DispatchQueue = DispatchQueue(label: "ConnectivityMonitor")
    
    var status: NWPath.Status = .requiresConnection
    var isConnected: Bool {
        return status == .satisfied
    }
    
    private init() {}
    
    func startMonitoring(){
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            if path.status == .satisfied {
                print("connected")
            } else {
                print("not connected")
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
}
