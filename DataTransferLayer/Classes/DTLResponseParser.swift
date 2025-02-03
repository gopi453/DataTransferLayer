//
//  ResponseParser.swift
//  DataTransferLayer
//
//  Created by GPS on 28/01/25.
//

import Foundation
public struct DTLResponse<Value> {
    private let urlResponse: URLResponse
    private let value: Value
    init(urlResponse: URLResponse, value: Value) {
        self.urlResponse = urlResponse
        self.value = value
    }

    public func getValue() -> Value {
        value
    }

    public var statusCode: Int {
        urlResponse.getStatusCode()
    }

    public var statusDescription: String {
        urlResponse.getStatusCodeDescription()
    }
}

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
   
    func parse() throws -> DTLResponse<Value> {
        guard error == nil,
              let response,
              response.hasValidStatusCode,
              let data,
              !data.isEmpty else {
            throw DTLError.response("Something went wrong.please try again")
        }
        return try decode(from: data, urlResponse: response)
    }
    
    private func decode(from data: Data, urlResponse: URLResponse) throws -> DTLResponse<Value> {
        // Attempt to decode the data into the provided type

        do {
            if let decodeType = Value.self as? Decodable.Type,
               let value = (try? decoder.decode(decodeType, from: data)) as? Value {
                let response: DTLResponse = .init(urlResponse: urlResponse, value: value)
                return response
            } else {
                if let object = try JSONSerialization.jsonObject(with: data, options: []) as? Value {
                    let response: DTLResponse = .init(urlResponse: urlResponse, value: object)
                    return response
                } else {
                    throw DTLError.response("Parsing failed with error")
                }
            }
        } catch {
            throw DTLError.response("Parsing failed with error:\n\(error.localizedDescription)")
        }
    }
    
}
