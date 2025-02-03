//
//  URLRequest+Extension.swift
//  DataTransferLayer
//
//  Created by Gopi Krishna on 28/01/25.
//

import Foundation

extension URLRequest {

    /// Generates a cURL command equivalent from the URLRequest.
    /// - Returns: A String representation of the cURL command.
    func toCurl() -> String {
        // Start constructing the cURL command with the HTTP method
        var curlCommand = "curl"

        // Add the HTTP method (GET, POST, PUT, DELETE, etc.)
        curlCommand += " -X \(httpMethod ?? "GET")"

        // Add headers to the cURL command
        if let headers = allHTTPHeaderFields {
            for (field, value) in headers {
                // Adding each header with proper formatting and escaping
                curlCommand += "\n  -H '\(field): \(value)'"
            }
        }

        // Add the HTTP body if present (only for POST, PUT, etc.)
        if let body = httpBody, let bodyString = String(data: body, encoding: .utf8) {
            curlCommand += "\n  -d '\(bodyString)'"
        }

        // Add the URL to the cURL command
        if let url = url {
            // Format the URL nicely and ensure it's quoted correctly
            curlCommand += "\n  '\(url.absoluteString)'"
        }

        return curlCommand
    }
}

extension URLResponse {
    
    func getStatusCode() -> Int {
        guard let httpResponse = self as? HTTPURLResponse else {
            return 0
        }
        return httpResponse.statusCode
    }
    
    func getStatusCodeDescription() -> String {
        guard let httpResponse = self as? HTTPURLResponse else {
            return ""
        }
        return HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
    }
    
    var hasValidStatusCode: Bool {
        guard (200...299) ~= getStatusCode() else {
            return false
        }
        return true
    }
}
