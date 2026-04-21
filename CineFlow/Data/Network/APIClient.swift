//
//  APIClient.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - API Client Protocol
protocol APIClientProtocol: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoints) async throws -> T
}

// MARK: - API Client
final class APIClient: APIClientProtocol, Sendable {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let apiKey: String

    static let shared = APIClient()

    init(
        session: URLSession = .shared,
        apiKey: String = AppConstants.tmdbAPIKey
    ) {
        self.session = session
        self.apiKey = apiKey

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoints) async throws -> T {
        let urlRequest = try endpoint.urlRequest(apiKey: apiKey)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(urlError.localizedDescription)
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.from(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError.localizedDescription)
        }
    }
}
