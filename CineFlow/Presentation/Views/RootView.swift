//
//  RootView.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI
import SwiftData

// MARK: - Root View
struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    private let container = DependencyContainer.shared

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            tabContent
                .navigationDestination(for: NavigationRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .tint(Color.cineAccent)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selectedTab: $coordinator.selectedTab)
        }
        .environmentObject(coordinator)
        .preferredColorScheme(.dark)
    }

    // MARK: - Tab Content
    @ViewBuilder
    private var tabContent: some View {
        switch coordinator.selectedTab {
        case .home:
            HomeView(viewModel: container.makeHomeViewModel())
        case .movies:
            MoviesTabView(viewModel: container.makeMoviesViewModel())
        case .series:
            SeriesTabView(viewModel: container.makeTVShowsViewModel())
        case .search:
            SearchView(viewModel: container.makeSearchViewModel())
        case .watchlist:
            WatchlistView()
        }
    }

    // MARK: - Navigation Destinations
    @ViewBuilder
    private func destinationView(for route: NavigationRoute) -> some View {
        switch route {
        case .movieDetail(let movie):
            MovieDetailView(viewModel: container.makeMovieDetailViewModel(movie: movie))
                .environmentObject(coordinator)

        case .tvShowDetail(let show):
            TVShowDetailView(viewModel: container.makeTVShowDetailViewModel(tvShow: show))
                .environmentObject(coordinator)

        case .movieList(let category, let title):
            MediaListView(
                title: title,
                mediaType: .movie,
                movieCategory: category
            )
            .environmentObject(coordinator)

        case .tvShowList(let category, let title):
            MediaListView(
                title: title,
                mediaType: .tvShow,
                tvShowCategory: category
            )
            .environmentObject(coordinator)

        case .search:
            SearchView(viewModel: container.makeSearchViewModel())
                .environmentObject(coordinator)
        }
    }
}
#Preview("Root View") {
    @Previewable @State var container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: WatchlistItem.self, configurations: config)
    }()
    
    RootView()
        .modelContainer(container)
}

