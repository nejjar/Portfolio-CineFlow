//
//  FetchTrendingUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Fetch Trending Use Case
protocol FetchTrendingUseCaseProtocol: Sendable {
    func executeTrendingMovies(page: Int) async throws -> [Movie]
    func executeTrendingTVShows(page: Int) async throws -> [TVShow]
}

final class FetchTrendingUseCase: FetchTrendingUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol
    private let tvShowRepository: TVShowRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol, tvShowRepository: TVShowRepositoryProtocol) {
        self.movieRepository = movieRepository
        self.tvShowRepository = tvShowRepository
    }

    func executeTrendingMovies(page: Int) async throws -> [Movie] {
        try await movieRepository.fetchTrending(page: page)
    }

    func executeTrendingTVShows(page: Int) async throws -> [TVShow] {
        try await tvShowRepository.fetchTrending(page: page)
    }
}
