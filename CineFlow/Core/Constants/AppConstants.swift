//
//  AppConstants.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

enum AppConstants {
    // MARK: - TMDB API
    static let tmdbAPIKey = Secrets.tmdbAPIKey
    static let tmdbAPIReadAccessToken = Secrets.tmdbAPIReadAccessToken

    enum API {
        static let baseURL = "https://api.themoviedb.org/3"
        static let imageBaseURL = "https://image.tmdb.org/t/p"
    }

    enum ImageSize {
        static let posterSmall = "/w185"
        static let posterMedium = "/w342"
        static let posterLarge = "/w500"
        static let backdropSmall = "/w780"
        static let backdropLarge = "/w1280"
        static let profileSmall = "/w185"
        static let original = "/original"
    }

    enum Pagination {
        static let defaultPage = 1
        static let itemsPerPage = 20
    }

    enum Animation {
        static let springResponse = 0.6
        static let springDamping = 0.8
        static let defaultDuration = 0.3
    }
}
