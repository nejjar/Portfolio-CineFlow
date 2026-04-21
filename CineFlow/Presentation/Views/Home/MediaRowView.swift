//
//  MediaRowView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Horizontal Media Row (Movies)
struct MovieRowView: View {
    let title: String
    let movies: [Movie]
    var isLoading: Bool = false
    var onSeeAll: (() -> Void)? = nil
    var onMovieTap: (Movie) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title, onAction: onSeeAll)
                .padding(.horizontal)

            if isLoading {
                SkeletonRow()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            Button {
                                onMovieTap(movie)
                            } label: {
                                MediaCard(
                                    posterURL: movie.posterPath.tmdbPosterURL(),
                                    title: movie.title,
                                    year: movie.releaseYear,
                                    rating: movie.voteAverage
                                )
                                .fadeInOnAppear(delay: Double(index) * 0.04)
                            }
                            .buttonStyle(PressScaleButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: - Horizontal Media Row (TV Shows)
struct TVShowRowView: View {
    let title: String
    let tvShows: [TVShow]
    var isLoading: Bool = false
    var onSeeAll: (() -> Void)? = nil
    var onTVShowTap: (TVShow) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title, onAction: onSeeAll)
                .padding(.horizontal)

            if isLoading {
                SkeletonRow()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(tvShows.enumerated()), id: \.element.id) { index, show in
                            Button {
                                onTVShowTap(show)
                            } label: {
                                MediaCard(
                                    posterURL: show.posterPath.tmdbPosterURL(),
                                    title: show.name,
                                    year: show.firstAirYear,
                                    rating: show.voteAverage
                                )
                                .fadeInOnAppear(delay: Double(index) * 0.04)
                            }
                            .buttonStyle(PressScaleButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
#Preview("Movie Row") {
    MovieRowView(
        title: "Popular Movies",
        movies: [.stub, .stub, .stub, .stub],
        isLoading: false,
        onSeeAll: {},
        onMovieTap: { _ in }
    )
    .background(Color.cineDark)
}

#Preview("Movie Row - Loading") {
    MovieRowView(
        title: "Popular Movies",
        movies: [],
        isLoading: true,
        onSeeAll: {},
        onMovieTap: { _ in }
    )
    .background(Color.cineDark)
}

#Preview("TV Show Row") {
    TVShowRowView(
        title: "Popular Series",
        tvShows: [.stub, .stub, .stub, .stub],
        isLoading: false,
        onSeeAll: {},
        onTVShowTap: { _ in }
    )
    .background(Color.cineDark)
}

#Preview("TV Show Row - Loading") {
    TVShowRowView(
        title: "Popular Series",
        tvShows: [],
        isLoading: true,
        onSeeAll: {},
        onTVShowTap: { _ in }
    )
    .background(Color.cineDark)
}


