//
//  NetworkMonitor.swift
//  BritaliansTV-tvOS
//
//  Created by miqo on 25.02.24.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async { @MainActor in
                self.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}
