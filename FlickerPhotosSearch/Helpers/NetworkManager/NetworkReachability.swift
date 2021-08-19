//
//  NetworkReachability.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 09/08/2021.
//

import Foundation

import Network

public class NetworkReachability {
    static let shared = NetworkReachability()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.status = path.status
            self.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
            
            print("Is Reachable: ", self.isReachable)
        }

        let queue = DispatchQueue(label: "NetworkReachability")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
