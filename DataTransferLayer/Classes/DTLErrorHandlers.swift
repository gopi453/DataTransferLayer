//
//  DTLErrorHandlers.swift
//  DataTransferLayer
//
//  Created by Gopi Krishna on 28/01/25.
//

import Foundation

public struct ErrorMessages {
    static let networkError = "Please check your network connection"
    static let responseError = "Something went wrong. Please try again later"
}

public enum DTLError: Error, LocalizedError {
    case request
    case response(String)
    case unknown
    case network
    public var errorDescription: String? {
        switch self {
        case .request, .unknown:
            ErrorMessages.responseError
        case .response:
            ErrorMessages.responseError
        case .network:
            ErrorMessages.networkError
        }
    }
}
