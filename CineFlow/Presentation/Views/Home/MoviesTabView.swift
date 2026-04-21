//
//  MoviesTabView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Movies Tab View
struct MoviesTabView: View {
    @StateObject private var viewModel: MoviesViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    init(viewModel: MoviesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.cineDark.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 28) {
                    Spacer(minLength: 100)

                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error) { Task { await viewModel.loadAll() } }
                    }

                    MovieRowView(
                        title: "Now Playing",
                        movies: viewModel.nowPlaying,
                        isLoading: viewModel.isLoading && viewModel.nowPlaying.isEmpty,
                        onSeeAll: { coordinator.push(.movieList(category: .nowPlaying, title: "Now Playing")) },
                        onMovieTap: { coordinator.push(.movieDetail($0)) }
                    )

                    MovieRowView(
                        title: "Popular",
                        movies: viewModel.popular,
                        isLoading: viewModel.isLoading && viewModel.popular.isEmpty,
                        onSeeAll: { coordinator.push(.movieList(category: .popular, title: "Popular Movies")) },
                        onMovieTap: { coordinator.push(.movieDetail($0)) }
                    )

                    MovieRowView(
                        title: "Top Rated",
                        movies: viewModel.topRated,
                        isLoading: viewModel.isLoading && viewModel.topRated.isEmpty,
                        onSeeAll: { coordinator.push(.movieList(category: .topRated, title: "Top Rated Movies")) },
                        onMovieTap: { coordinator.push(.movieDetail($0)) }
                    )

                    MovieRowView(
                        title: "Upcoming",
                        movies: viewModel.upcoming,
                        isLoading: viewModel.isLoading && viewModel.upcoming.isEmpty,
                        onSeeAll: { coordinator.push(.movieList(category: .upcoming, title: "Upcoming Movies")) },
                        onMovieTap: { coordinator.push(.movieDetail($0)) }
                    )

                    Spacer(minLength: 20)
                }
            }

            tabHeader(title: "Movies", icon: "film.fill")
        }
        .task { await viewModel.loadAll() }
    }
}

// MARK: - Series Tab View
struct SeriesTabView: View {
    @StateObject private var viewModel: TVShowsViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    init(viewModel: TVShowsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.cineDark.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 28) {
                    Spacer(minLength: 100)

                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error) { Task { await viewModel.loadAll() } }
                    }

                    TVShowRowView(
                        title: "On The Air",
                        tvShows: viewModel.onTheAir,
                        isLoading: viewModel.isLoading && viewModel.onTheAir.isEmpty,
                        onSeeAll: { coordinator.push(.tvShowList(category: .onTheAir, title: "On The Air")) },
                        onTVShowTap: { coordinator.push(.tvShowDetail($0)) }
                    )

                    TVShowRowView(
                        title: "Popular",
                        tvShows: viewModel.popular,
                        isLoading: viewModel.isLoading && viewModel.popular.isEmpty,
                        onSeeAll: { coordinator.push(.tvShowList(category: .popular, title: "Popular Series")) },
                        onTVShowTap: { coordinator.push(.tvShowDetail($0)) }
                    )

                    TVShowRowView(
                        title: "Top Rated",
                        tvShows: viewModel.topRated,
                        isLoading: viewModel.isLoading && viewModel.topRated.isEmpty,
                        onSeeAll: { coordinator.push(.tvShowList(category: .topRated, title: "Top Rated Series")) },
                        onTVShowTap: { coordinator.push(.tvShowDetail($0)) }
                    )

                    Spacer(minLength: 20)
                }
            }

            tabHeader(title: "Series", icon: "tv.fill")
        }
        .task { await viewModel.loadAll() }
    }
}

// MARK: - Shared tab header
private func tabHeader(title: String, icon: String) -> some View {
    HStack(spacing: 10) {
        Image(systemName: icon)
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(Color.cineAccent)
        Text(title)
            .font(.system(size: 26, weight: .black))
            .foregroundStyle(.white)
        Spacer()
    }
    .padding(.horizontal, 20)
    .padding(.top, 60)
    .padding(.bottom, 16)
    .background(
        LinearGradient(
            colors: [Color.cineDark, Color.cineDark.opacity(0)],
            startPoint: .top, endPoint: .bottom
        )
    )
}
#Preview("Movies Tab") {
    MoviesTabView(viewModel: MoviesViewModel(
        fetchPopularUseCase: MockFetchPopularUseCase(),
        fetchTopRatedUseCase: MockFetchTopRatedUseCase(),
        fetchNowPlayingUseCase: MockFetchNowPlayingUseCase(),
        fetchUpcomingUseCase: MockFetchUpcomingUseCase()
    ))
    .environmentObject(PreviewCoordinator())
}

#Preview("Series Tab") {
    SeriesTabView(viewModel: TVShowsViewModel(
        fetchPopularUseCase: MockFetchPopularUseCase(),
        fetchTopRatedUseCase: MockFetchTopRatedUseCase(),
        fetchOnTheAirUseCase: MockFetchOnTheAirUseCase()
    ))
    .environmentObject(PreviewCoordinator())
}

