//
//  TVShowRepositoryProtocol.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - TV Show Repository Protocol
protocol TVShowRepositoryProtocol: Sendable {
    func fetchTrending(page: Int) async throws -> [TVShow]
    func fetchPopular(page: Int) async throws -> [TVShow]
    func fetchTopRated(page: Int) async throws -> [TVShow]
    func fetchOnTheAir(page: Int) async throws -> [TVShow]
    func fetchDetail(id: Int) async throws -> TVShow
    func search(query: String, page: Int) async throws -> [TVShow]
}
