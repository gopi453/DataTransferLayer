//
//  ResponseParser.swift
//  NetForge
//
//  Created by GPS on 28/01/25.
//

import Foundation

struct ResponseParser<Value> {
    private let data: Data?
    private let response: URLResponse?
    private let error: Error?
    private let decoder: JSONDecoder

    init(data: Data?, response: URLResponse?, error: Error? = nil, decoder: JSONDecoder = .init()) {
        self.data = data
        self.response = response
        self.error = error
        self.decoder = decoder
    }
   
    func parse() throws -> Value {
        if let error = error {
            throw NetworkError.response(error.localizedDescription)
        }
        if let response, !response.hasValidStatusCode {
            throw NetworkError.response(response.getStatusCodeDescription())
        }
        guard let data = data, !data.isEmpty else {
            throw NetworkError.response("No data found")
        }
        return try decode(from: data)
    }
    
    private func decode(from data: Data) throws -> Value {
        // Attempt to decode the data into the provided type
        do {
            if let decodeType = Value.self as? Decodable.Type,
               let value = (try? decoder.decode(decodeType, from: data)) as? Value {
                return value
            } else {
                if let object = try JSONSerialization.jsonObject(with: data, options: []) as? Value {
                    return object
                } else {
                    throw NetworkError.response("Parsing failed with error")
                }
            }
        } catch {
            throw NetworkError.response("Parsing failed with error:\n\(error.localizedDescription)")
        }
    }
    
}
