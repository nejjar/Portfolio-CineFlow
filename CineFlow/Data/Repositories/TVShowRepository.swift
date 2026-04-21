//
//  TVShowRepository.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - TV Show Repository
final class TVShowRepository: TVShowRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchTrending(page: Int) async throws -> [TVShow] {
        let response: PagedResponseDTO<TVShowDTO> = try await apiClient.request(.trendingTVShows(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchPopular(page: Int) async throws -> [TVShow] {
        let response: PagedResponseDTO<TVShowDTO> = try await apiClient.request(.popularTVShows(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchTopRated(page: Int) async throws -> [TVShow] {
        let response: PagedResponseDTO<TVShowDTO> = try await apiClient.request(.topRatedTVShows(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchOnTheAir(page: Int) async throws -> [TVShow] {
        let response: PagedResponseDTO<TVShowDTO> = try await apiClient.request(.onTheAirTVShows(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchDetail(id: Int) async throws -> TVShow {
        let dto: TVShowDTO = try await apiClient.request(.tvShowDetail(id: id))
        return dto.toDomain()
    }

    func search(query: String, page: Int) async throws -> [TVShow] {
        let response: PagedResponseDTO<TVShowDTO> = try await apiClient.request(.searchTVShows(query: query, page: page))
        return response.results.map { $0.toDomain() }
    }
}
