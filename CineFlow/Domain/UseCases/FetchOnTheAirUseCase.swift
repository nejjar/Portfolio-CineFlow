//
//  FetchOnTheAirUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Fetch On The Air Use Case
protocol FetchOnTheAirUseCaseProtocol: Sendable {
    func execute(page: Int) async throws -> [TVShow]
}

final class FetchOnTheAirUseCase: FetchOnTheAirUseCaseProtocol {
    private let repository: TVShowRepositoryProtocol

    init(repository: TVShowRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [TVShow] {
        try await repository.fetchOnTheAir(page: page)
    }
}
