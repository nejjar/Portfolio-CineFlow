//
//  APIEndpoints.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - API Endpoints
enum APIEndpoints {
    // MARK: Movies
    case trendingMovies(page: Int)
    case popularMovies(page: Int)
    case topRatedMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case upcomingMovies(page: Int)
    case movieDetail(id: Int)
    case searchMovies(query: String, page: Int)

    // MARK: TV Shows
    case trendingTVShows(page: Int)
    case popularTVShows(page: Int)
    case topRatedTVShows(page: Int)
    case onTheAirTVShows(page: Int)
    case tvShowDetail(id: Int)
    case searchTVShows(query: String, page: Int)

    // MARK: - Path
    var path: String {
        switch self {
        case .trendingMovies:       return "/trending/movie/week"
        case .popularMovies:        return "/movie/popular"
        case .topRatedMovies:       return "/movie/top_rated"
        case .nowPlayingMovies:     return "/movie/now_playing"
        case .upcomingMovies:       return "/movie/upcoming"
        case .movieDetail(let id):  return "/movie/\(id)"
        case .searchMovies:         return "/search/movie"

        case .trendingTVShows:      return "/trending/tv/week"
        case .popularTVShows:       return "/tv/popular"
        case .topRatedTVShows:      return "/tv/top_rated"
        case .onTheAirTVShows:      return "/tv/on_the_air"
        case .tvShowDetail(let id): return "/tv/\(id)"
        case .searchTVShows:        return "/search/tv"
        }
    }

    // MARK: - Query Parameters
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []

        switch self {
        case .trendingMovies(let page), .popularMovies(let page),
             .topRatedMovies(let page), .nowPlayingMovies(let page),
             .upcomingMovies(let page), .trendingTVShows(let page),
             .popularTVShows(let page), .topRatedTVShows(let page),
             .onTheAirTVShows(let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))

        case .movieDetail, .tvShowDetail:
            items.append(URLQueryItem(name: "append_to_response", value: "credits,similar,videos"))

        case .searchMovies(let query, let page), .searchTVShows(let query, let page):
            items.append(URLQueryItem(name: "query", value: query))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        }

        return items
    }

    // MARK: - Build URL Request
    func urlRequest(apiKey: String) throws -> URLRequest {
        var components = URLComponents(string: AppConstants.API.baseURL + path)
        var allQueryItems = queryItems
        allQueryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        allQueryItems.append(URLQueryItem(name: "language", value: Locale.current.language.languageCode?.identifier ?? "en"))
        components?.queryItems = allQueryItems

        guard let url = components?.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
