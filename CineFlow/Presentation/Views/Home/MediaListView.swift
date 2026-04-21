//
//  MediaListView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Full Media List View (Grid)
struct MediaListView: View {
    let title: String
    let mediaType: MediaType
    var movieCategory: MovieCategory? = nil
    var tvShowCategory: TVShowCategory? = nil

    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss

    @State private var movies: [Movie] = []
    @State private var tvShows: [TVShow] = []
    @State private var isLoading = false
    @State private var currentPage = 1
    @State private var canLoadMore = true
    @State private var errorMessage: String?

    private let container = DependencyContainer.shared
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible())]

    var body: some View {
        ZStack {
            Color.cineDark.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    if mediaType == .movie {
                        ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            Button { coordinator.push(.movieDetail(movie)) } label: {
                                MediaCard(
                                    posterURL: movie.posterPath.tmdbPosterURL(),
                                    title: movie.title,
                                    year: movie.releaseYear,
                                    rating: movie.voteAverage,
                                    width: nil
                                )
                                .fadeInOnAppear(delay: Double(index % 6) * 0.05)
                            }
                            .buttonStyle(PressScaleButtonStyle())
                            .onAppear {
                                if movie.id == movies.last?.id { loadNextPage() }
                            }
                        }
                    } else {
                        ForEach(Array(tvShows.enumerated()), id: \.element.id) { index, show in
                            Button { coordinator.push(.tvShowDetail(show)) } label: {
                                MediaCard(
                                    posterURL: show.posterPath.tmdbPosterURL(),
                                    title: show.name,
                                    year: show.firstAirYear,
                                    rating: show.voteAverage,
                                    width: nil
                                )
                                .fadeInOnAppear(delay: Double(index % 6) * 0.05)
                            }
                            .buttonStyle(PressScaleButtonStyle())
                            .onAppear {
                                if show.id == tvShows.last?.id { loadNextPage() }
                            }
                        }
                    }

                    if isLoading {
                        ForEach(0..<6, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.cineCard)
                                .aspectRatio(2/3, contentMode: .fit)
                                .shimmer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task { await loadPage(1) }
    }

    private func loadNextPage() {
        guard !isLoading && canLoadMore else { return }
        Task { await loadPage(currentPage + 1) }
    }

    private func loadPage(_ page: Int) async {
        isLoading = true
        do {
            if mediaType == .movie, let category = movieCategory {
                let newMovies = try await fetchMovies(category: category, page: page)
                withAnimation {
                    if page == 1 { movies = newMovies }
                    else { movies.append(contentsOf: newMovies) }
                }
                canLoadMore = !newMovies.isEmpty
            } else if mediaType == .tvShow, let category = tvShowCategory {
                let newShows = try await fetchTVShows(category: category, page: page)
                withAnimation {
                    if page == 1 { tvShows = newShows }
                    else { tvShows.append(contentsOf: newShows) }
                }
                canLoadMore = !newShows.isEmpty
            }
            currentPage = page
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func fetchMovies(category: MovieCategory, page: Int) async throws -> [Movie] {
        switch category {
        case .trending:    return try await container.fetchTrendingUseCase.executeTrendingMovies(page: page)
        case .popular:     return try await container.fetchPopularUseCase.executeMovies(page: page)
        case .topRated:    return try await container.fetchTopRatedUseCase.executeMovies(page: page)
        case .nowPlaying:  return try await container.fetchNowPlayingUseCase.execute(page: page)
        case .upcoming:    return try await container.fetchUpcomingUseCase.execute(page: page)
        }
    }

    private func fetchTVShows(category: TVShowCategory, page: Int) async throws -> [TVShow] {
        switch category {
        case .trending:   return try await container.fetchTrendingUseCase.executeTrendingTVShows(page: page)
        case .popular:    return try await container.fetchPopularUseCase.executeTVShows(page: page)
        case .topRated:   return try await container.fetchTopRatedUseCase.executeTVShows(page: page)
        case .onTheAir:   return try await container.fetchOnTheAirUseCase.execute(page: page)
        }
    }
}
#Preview("Media List - Movies") {
    MediaListView(
        title: "Popular Movies",
        mediaType: .movie,
        movieCategory: .popular
    )
    .environmentObject(PreviewCoordinator())
}

#Preview("Media List - TV Shows") {
    MediaListView(
        title: "Popular Series",
        mediaType: .tvShow,
        tvShowCategory: .popular
    )
    .environmentObject(PreviewCoordinator())
}

