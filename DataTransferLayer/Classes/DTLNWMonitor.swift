//
//  File.swift
//  DataTransferLayer
//
//  Created by K Gopi on 14/02/25.
//

import Foundation
import Network

protocol DTLReachabilityProtocol {
    func execute() throws
}

final class DTLNWMonitor: DTLReachabilityProtocol {

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    private var isConnected = false

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue.global(qos: .background)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: self.queue)
    }

    func execute() throws {
        if isConnected {
            return
        }
        throw DTLError.network
    }
}
