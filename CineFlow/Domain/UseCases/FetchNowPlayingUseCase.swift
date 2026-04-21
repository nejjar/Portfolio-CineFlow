//
//  FetchNowPlayingUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Fetch Now Playing Use Case
protocol FetchNowPlayingUseCaseProtocol: Sendable {
    func execute(page: Int) async throws -> [Movie]
}

final class FetchNowPlayingUseCase: FetchNowPlayingUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [Movie] {
        try await repository.fetchNowPlaying(page: page)
    }
}
