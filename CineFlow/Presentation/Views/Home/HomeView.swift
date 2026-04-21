//
//  HomeView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.cineDark.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 28) {
                    // Featured Banner
                    FeaturedBannerView(
                        movies: viewModel.featuredMovies,
                        currentIndex: $viewModel.currentFeaturedIndex,
                        onMovieTap: { coordinator.push(.movieDetail($0)) },
                        onAutoAdvance: { viewModel.advanceFeatured() }
                    )

                    if let error = viewModel.errorMessage {
                        ErrorBanner(message: error) {
                            Task { await viewModel.loadAll() }
                        }
                    }

                    // Trending Movies
                    MovieRowView(
                        title: "Trending Movies",
                        movies: viewModel.trendingMovies,
                        isLoading: viewModel.isLoading && viewModel.trendingMovies.isEmpty,
                        onSeeAll: { coordinator.push(.movieList(category: .trending, title: "Trending Movies")) },
                        onMovieTap: { coordinator.push(.movieDetail($0)) }
                    )

                    // Trending Series
                    TVShowRowView(
                        title: "Trending Series",
                        tvShows: viewModel.trendingTVShows,
                        isLoading: viewModel.isLoading && viewModel.trendingTVShows.isEmpty,
                        onSeeAll: { coordinator.push(.tvShowList(category: .trending, title: "Trending Series")) },
                        onTVShowTap: { coordinator.push(.tvShowDetail($0)) }
                    )

                    // Popular Movies
                    MovieRowView(
                        title: "Popular Movies",
                        movies: viewModel.popularMovies,
                        isLoading: viewModel.isLoading && viewModel.popularMovies.isEmpty,
                        onSeeAll: { coordinator.push(.movieList(category: .popular, title: "Popular Movies")) },
                        onMovieTap: { coordinator.push(.movieDetail($0)) }
                    )

                    // Top Rated Movies
                    MovieRowView(
                        title: "Top Rated",
                        movies: viewModel.topRatedMovies,
                        isLoading: viewModel.isLoading && viewModel.topRatedMovies.isEmpty,
                        onSeeAll: { coordinator.push(.movieList(category: .topRated, title: "Top Rated Movies")) },
                        onMovieTap: { coordinator.push(.movieDetail($0)) }
                    )

                    // Popular Series
                    TVShowRowView(
                        title: "Popular Series",
                        tvShows: viewModel.popularTVShows,
                        isLoading: viewModel.isLoading && viewModel.popularTVShows.isEmpty,
                        onSeeAll: { coordinator.push(.tvShowList(category: .popular, title: "Popular Series")) },
                        onTVShowTap: { coordinator.push(.tvShowDetail($0)) }
                    )

                    Spacer(minLength: 20)
                }
            }
            .ignoresSafeArea(edges: .top)

            // Floating top bar
            topBar
        }
        .task { await viewModel.loadAll() }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("homeView")
    }

    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("CineFlow")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, Color.cineAccent], startPoint: .leading, endPoint: .trailing)
                    )
                Text("Discover what's great")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.cineSubtitle)
            }
            Spacer()
            Button {
                coordinator.navigate(to: .search)
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.cineGlass))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 12)
        .background(
            LinearGradient(
                colors: [Color.cineDark, Color.cineDark.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
#Preview("Home View") {
    HomeView(viewModel: HomeViewModel(
        fetchTrendingUseCase: MockFetchTrendingUseCase(),
        fetchPopularUseCase: MockFetchPopularUseCase(),
        fetchTopRatedUseCase: MockFetchTopRatedUseCase()
    ))
    .environmentObject(PreviewCoordinator())
}

#Preview("Home View - Loading") {
    let viewModel = HomeViewModel(
        fetchTrendingUseCase: MockFetchTrendingUseCase(),
        fetchPopularUseCase: MockFetchPopularUseCase(),
        fetchTopRatedUseCase: MockFetchTopRatedUseCase()
    )
    viewModel.isLoading = true
    return HomeView(viewModel: viewModel)
        .environmentObject(PreviewCoordinator())
}

