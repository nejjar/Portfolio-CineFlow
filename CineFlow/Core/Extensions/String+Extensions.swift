//
//  String+Extensions.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

extension String {
    func tmdbPosterURL(size: String = AppConstants.ImageSize.posterLarge) -> URL? {
        guard !isEmpty else { return nil }
        let path = self.hasPrefix("/") ? self : "/\(self)"
        return URL(string: "\(AppConstants.API.imageBaseURL)\(size)\(path)")
    }

    func tmdbBackdropURL(size: String = AppConstants.ImageSize.backdropLarge) -> URL? {
        guard !isEmpty else { return nil }
        let path = self.hasPrefix("/") ? self : "/\(self)"
        return URL(string: "\(AppConstants.API.imageBaseURL)\(size)\(path)")
    }

    func tmdbProfileURL(size: String = AppConstants.ImageSize.profileSmall) -> URL? {
        guard !isEmpty else { return nil }
        let path = self.hasPrefix("/") ? self : "/\(self)"
        return URL(string: "\(AppConstants.API.imageBaseURL)\(size)\(path)")
    }
}

extension Optional where Wrapped == String {
    func tmdbPosterURL(size: String = AppConstants.ImageSize.posterLarge) -> URL? {
        self?.tmdbPosterURL(size: size)
    }

    func tmdbBackdropURL(size: String = AppConstants.ImageSize.backdropLarge) -> URL? {
        self?.tmdbBackdropURL(size: size)
    }
}
