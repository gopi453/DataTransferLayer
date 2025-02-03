//
//  NetworkManager.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import Foundation
import Combine

public final class NetworkManager {
    private static let sharedInstance = NetworkManager()
    private let session: URLSession
    
    public class func shared() -> NetworkManager {
        return sharedInstance
    }
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    @available(iOS 15.0, *)
    @MainActor
    public func makeAsyncRequest<T>(from request: RequestBuilder) async throws -> T {
        let urlRequest = try createURLRequest(from: request)
        let (data, response) = try await session.data(for: urlRequest)
        return try self.parseResponse(data: data, response: response)
    }
    
    @available(iOS 13.0, *)
    public func makePublisherRequest<T>(from request: RequestBuilder) throws -> AnyPublisher<T, NetworkError> {
        do {
            let urlRequest = try createURLRequest(from: request)
            return self.session.dataTaskPublisher(for: urlRequest)
                .tryMap({ (data: Data, response: URLResponse) -> T in
                    let response:T = try self.parseResponse(data: data, response: response)
                    return response
                })
                .mapError { error in
                    (error as? NetworkError) ?? .unknown
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.request).eraseToAnyPublisher()
        }
    }

    public func makeRequest<T>(from request: RequestBuilder,_ completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let urlRequest = try createURLRequest(from: request)
            self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self else { return }
                do {
                    let response:T = try self.parseResponse(data: data, response: response, error: error)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.response(error.localizedDescription)))
                    }
                }
            }.resume()
        }  catch {
            completion(.failure(NetworkError.request))
        }
        
    }
}

private extension NetworkManager {
    func createURLRequest(from request: RequestBuilder) throws -> URLRequest {
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

    func parseResponse<T>(data: Data?, response: URLResponse?, error: Error? = nil) throws -> T {
        let responseParser = ResponseParser<T>(data: data, response: response, error: error)
        return try responseParser.parse()
    }
}

