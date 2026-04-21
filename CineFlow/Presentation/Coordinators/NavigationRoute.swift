//
//  NavigationRoute.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

// MARK: - Navigation Routes
enum NavigationRoute: Hashable {
    case movieDetail(Movie)
    case tvShowDetail(TVShow)
    case movieList(category: MovieCategory, title: String)
    case tvShowList(category: TVShowCategory, title: String)
    case search
}

// MARK: - Movie Category
enum MovieCategory: String, Hashable {
    case trending = "Trending Movies"
    case popular = "Popular Movies"
    case topRated = "Top Rated Movies"
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
}

// MARK: - TV Show Category
enum TVShowCategory: String, Hashable {
    case trending = "Trending Series"
    case popular = "Popular Series"
    case topRated = "Top Rated Series"
    case onTheAir = "On The Air"
}
