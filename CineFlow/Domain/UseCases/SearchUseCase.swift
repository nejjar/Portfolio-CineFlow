//
//  SearchUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Search Use Case
protocol SearchUseCaseProtocol: Sendable {
    func execute(query: String, page: Int) async throws -> SearchResults
}

struct SearchResults: Sendable {
    let movies: [Movie]
    let tvShows: [TVShow]
    let query: String
    let page: Int
}

final class SearchUseCase: SearchUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol
    private let tvShowRepository: TVShowRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol, tvShowRepository: TVShowRepositoryProtocol) {
        self.movieRepository = movieRepository
        self.tvShowRepository = tvShowRepository
    }

    func execute(query: String, page: Int) async throws -> SearchResults {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return SearchResults(movies: [], tvShows: [], query: trimmed, page: page)
        }

        async let movies = movieRepository.search(query: trimmed, page: page)
        async let tvShows = tvShowRepository.search(query: trimmed, page: page)

        return try await SearchResults(
            movies: movies,
            tvShows: tvShows,
            query: trimmed,
            page: page
        )
    }
}
