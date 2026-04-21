//
//  FetchUpcomingUseCase.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Fetch Upcoming Use Case
protocol FetchUpcomingUseCaseProtocol: Sendable {
    func execute(page: Int) async throws -> [Movie]
}

final class FetchUpcomingUseCase: FetchUpcomingUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [Movie] {
        try await repository.fetchUpcoming(page: page)
    }
}
