//
//  DTLClient.swift
//  DataTransferLayer
//
//  Created by Gopi Krishna on 28/01/25.
//

import Foundation
import Combine

public final class DTLClient {
    private static let sharedInstance = DTLClient()
    private let session: URLSession

    public class func shared() -> DTLClient {
        return sharedInstance
    }
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    @available(iOS 15.0, *)
    @MainActor
    public func makeAsyncRequest<T>(from request: DTLRequestBuilder) async throws -> DTLResponse<T> {
        let urlRequest = try createURLRequest(from: request)
        let (data, response) = try await session.data(for: urlRequest)
        return try self.parseResponse(data: data, response: response)
    }
    
    @available(iOS 13.0, *)
    public func makePublisherRequest<T>(from request: DTLRequestBuilder) throws -> AnyPublisher<DTLResponse<T>, DTLError> {
        do {
            let urlRequest = try createURLRequest(from: request)
            return self.session.dataTaskPublisher(for: urlRequest)
                .tryMap({ (data: Data, response: URLResponse) -> DTLResponse<T> in
                    let response:DTLResponse<T> = try self.parseResponse(data: data, response: response)
                    return response
                })
                .mapError { error in
                    (error as? DTLError) ?? .unknown
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: DTLError.request).eraseToAnyPublisher()
        }
    }

    public func makeRequest<T>(from request: DTLRequestBuilder,_ completion: @escaping (Result<DTLResponse<T>, DTLError>) -> Void) {
        do {
            let urlRequest = try createURLRequest(from: request)
            self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self else { return }
                do {
                    let response:DTLResponse<T> = try self.parseResponse(data: data, response: response, error: error)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    let errorResponse: DTLError = .response(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(.failure(errorResponse))
                    }
                }
            }.resume()
        }  catch {
            completion(.failure(DTLError.request))
        }
    }
}

private extension DTLClient {
    func createURLRequest(from request: DTLRequestBuilder) throws -> URLRequest {
        let url = try request.getURL()
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: request.timeoutInterval)
        urlRequest.httpMethod = request.method.description
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers
#if DEBUG
        print(urlRequest.toCurl())
#endif
        return urlRequest
    }

    func parseResponse<T>(data: Data?, response: URLResponse?, error: Error? = nil) throws -> DTLResponse<T> {
        let responseParser = ResponseParser<T>(data: data, response: response, error: error)
        return try responseParser.parse()
    }
}

