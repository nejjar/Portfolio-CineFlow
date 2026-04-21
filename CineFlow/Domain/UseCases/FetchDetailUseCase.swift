//
//  FetchDetailUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Fetch Detail Use Case
protocol FetchDetailUseCaseProtocol: Sendable {
    func executeMovie(id: Int) async throws -> Movie
    func executeTVShow(id: Int) async throws -> TVShow
}

final class FetchDetailUseCase: FetchDetailUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol
    private let tvShowRepository: TVShowRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol, tvShowRepository: TVShowRepositoryProtocol) {
        self.movieRepository = movieRepository
        self.tvShowRepository = tvShowRepository
    }

    func executeMovie(id: Int) async throws -> Movie {
        try await movieRepository.fetchDetail(id: id)
    }

    func executeTVShow(id: Int) async throws -> TVShow {
        try await tvShowRepository.fetchDetail(id: id)
    }
}
