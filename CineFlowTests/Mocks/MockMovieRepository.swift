//
//  MockMovieRepository.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation
@testable import CineFlow

// MARK: - Mock Movie Repository
final class MockMovieRepository: MovieRepositoryProtocol {
    nonisolated(unsafe) var trendingMovies: [Movie] = [Movie.stub]
    nonisolated(unsafe) var popularMovies: [Movie] = [Movie.stub]
    nonisolated(unsafe) var topRatedMovies: [Movie] = [Movie.stub]
    nonisolated(unsafe) var nowPlayingMovies: [Movie] = [Movie.stub]
    nonisolated(unsafe) var upcomingMovies: [Movie] = [Movie.stub]
    nonisolated(unsafe) var detailMovie: Movie = Movie.stub
    nonisolated(unsafe) var searchMovies: [Movie] = [Movie.stub]
    nonisolated(unsafe) var shouldThrow: NetworkError? = nil

    private func throwIfNeeded() throws {
        if let error = shouldThrow { throw error }
    }

    func fetchTrending(page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        return trendingMovies
    }

    func fetchPopular(page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        return popularMovies
    }

    func fetchTopRated(page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        return topRatedMovies
    }

    func fetchNowPlaying(page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        return nowPlayingMovies
    }

    func fetchUpcoming(page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        return upcomingMovies
    }

    func fetchDetail(id: Int) async throws -> Movie {
        try throwIfNeeded()
        return detailMovie
    }

    func search(query: String, page: Int) async throws -> [Movie] {
        try throwIfNeeded()
        return searchMovies
    }
}
