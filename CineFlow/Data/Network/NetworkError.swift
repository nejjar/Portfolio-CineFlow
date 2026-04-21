//
//  NetworkError.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Network Error
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(String)
    case noInternetConnection
    case timeout
    case unauthorized
    case notFound
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .httpError(let statusCode):
            return "Server returned status code \(statusCode)."
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        case .noInternetConnection:
            return "No internet connection. Please check your network."
        case .timeout:
            return "The request timed out. Please try again."
        case .unauthorized:
            return "Unauthorized. Please check your API key."
        case .notFound:
            return "The requested resource was not found."
        case .unknown(let message):
            return message
        }
    }

    static func from(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401: return .unauthorized
        case 404: return .notFound
        default: return .httpError(statusCode: statusCode)
        }
    }
}
