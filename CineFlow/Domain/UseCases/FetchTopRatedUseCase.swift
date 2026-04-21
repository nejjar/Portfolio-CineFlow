//
//  FetchTopRatedUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Fetch Top Rated Use Case
protocol FetchTopRatedUseCaseProtocol: Sendable {
    func executeMovies(page: Int) async throws -> [Movie]
    func executeTVShows(page: Int) async throws -> [TVShow]
}

final class FetchTopRatedUseCase: FetchTopRatedUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol
    private let tvShowRepository: TVShowRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol, tvShowRepository: TVShowRepositoryProtocol) {
        self.movieRepository = movieRepository
        self.tvShowRepository = tvShowRepository
    }

    func executeMovies(page: Int) async throws -> [Movie] {
        try await movieRepository.fetchTopRated(page: page)
    }

    func executeTVShows(page: Int) async throws -> [TVShow] {
        try await tvShowRepository.fetchTopRated(page: page)
    }
}
