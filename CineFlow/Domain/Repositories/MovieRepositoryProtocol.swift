//
//  MovieRepositoryProtocol.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Movie Repository Protocol
protocol MovieRepositoryProtocol: Sendable {
    func fetchTrending(page: Int) async throws -> [Movie]
    func fetchPopular(page: Int) async throws -> [Movie]
    func fetchTopRated(page: Int) async throws -> [Movie]
    func fetchNowPlaying(page: Int) async throws -> [Movie]
    func fetchUpcoming(page: Int) async throws -> [Movie]
    func fetchDetail(id: Int) async throws -> Movie
    func search(query: String, page: Int) async throws -> [Movie]
}
