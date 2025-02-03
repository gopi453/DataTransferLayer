//
//  RequestBuilder.swift
//  DataTransferLayer
//
//  Created by Gopi Krishna on 28/01/25.
//

import Foundation

public enum HTTPMethod:String, CustomStringConvertible {
    case get, post, patch, put, delete
    public var description: String {
        self.rawValue.uppercased()
    }
}

public protocol DTLRequestBuilder {
    var baseURL: String? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var timeoutInterval: TimeInterval { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String] { get }
}

public extension DTLRequestBuilder {
    var path: String { "" }
    var baseURL: String? { nil }
    var method: HTTPMethod { .get }
    var timeoutInterval: TimeInterval { 15 }
    var body: Data? { nil }
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    var queryItems: [URLQueryItem]? { nil }
    func getURL() throws -> URL {
        guard let baseURL else { throw DTLError.request }
        var components = URLComponents(string: baseURL)
        components?.path = "/\(path)"
        components?.queryItems = queryItems
        guard let url = components?.url else { throw DTLError.request }
        return url
    }
}
