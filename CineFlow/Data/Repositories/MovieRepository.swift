//
//  MovieRepository.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Movie Repository
final class MovieRepository: MovieRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchTrending(page: Int) async throws -> [Movie] {
        let response: PagedResponseDTO<MovieDTO> = try await apiClient.request(.trendingMovies(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchPopular(page: Int) async throws -> [Movie] {
        let response: PagedResponseDTO<MovieDTO> = try await apiClient.request(.popularMovies(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchTopRated(page: Int) async throws -> [Movie] {
        let response: PagedResponseDTO<MovieDTO> = try await apiClient.request(.topRatedMovies(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchNowPlaying(page: Int) async throws -> [Movie] {
        let response: PagedResponseDTO<MovieDTO> = try await apiClient.request(.nowPlayingMovies(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchUpcoming(page: Int) async throws -> [Movie] {
        let response: PagedResponseDTO<MovieDTO> = try await apiClient.request(.upcomingMovies(page: page))
        return response.results.map { $0.toDomain() }
    }

    func fetchDetail(id: Int) async throws -> Movie {
        let dto: MovieDTO = try await apiClient.request(.movieDetail(id: id))
        return dto.toDomain()
    }

    func search(query: String, page: Int) async throws -> [Movie] {
        let response: PagedResponseDTO<MovieDTO> = try await apiClient.request(.searchMovies(query: query, page: page))
        return response.results.map { $0.toDomain() }
    }
}
