//
//  MockTVShowRepository.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
@testable import CineFlow

// MARK: - Mock TV Show Repository
final class MockTVShowRepository: TVShowRepositoryProtocol {
    nonisolated(unsafe) var trendingShows: [TVShow] = [TVShow.stub]
    nonisolated(unsafe) var popularShows: [TVShow] = [TVShow.stub]
    nonisolated(unsafe) var topRatedShows: [TVShow] = [TVShow.stub]
    nonisolated(unsafe) var onTheAirShows: [TVShow] = [TVShow.stub]
    nonisolated(unsafe) var detailShow: TVShow = TVShow.stub
    nonisolated(unsafe) var searchShows: [TVShow] = [TVShow.stub]
    nonisolated(unsafe) var shouldThrow: NetworkError? = nil

    private func throwIfNeeded() throws {
        if let error = shouldThrow { throw error }
    }

    func fetchTrending(page: Int) async throws -> [TVShow] {
        try throwIfNeeded(); return trendingShows
    }

    func fetchPopular(page: Int) async throws -> [TVShow] {
        try throwIfNeeded(); return popularShows
    }

    func fetchTopRated(page: Int) async throws -> [TVShow] {
        try throwIfNeeded(); return topRatedShows
    }

    func fetchOnTheAir(page: Int) async throws -> [TVShow] {
        try throwIfNeeded(); return onTheAirShows
    }

    func fetchDetail(id: Int) async throws -> TVShow {
        try throwIfNeeded(); return detailShow
    }

    func search(query: String, page: Int) async throws -> [TVShow] {
        try throwIfNeeded(); return searchShows
    }
}
