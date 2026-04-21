//
//  AppCoordinator.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - App Coordinator
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var selectedTab: AppTab = .home

    func push(_ route: NavigationRoute) {
        navigationPath.append(route)
    }

    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }

    func navigate(to tab: AppTab) {
        selectedTab = tab
    }
}

// MARK: - App Tab
enum AppTab: Int, CaseIterable {
    case home
    case movies
    case series
    case search
    case watchlist

    var title: String {
        switch self {
        case .home:      return "Home"
        case .movies:    return "Movies"
        case .series:    return "Series"
        case .search:    return "Search"
        case .watchlist: return "Watchlist"
        }
    }

    var icon: String {
        switch self {
        case .home:      return "house.fill"
        case .movies:    return "film.fill"
        case .series:    return "tv.fill"
        case .search:    return "magnifyingglass"
        case .watchlist: return "bookmark.fill"
        }
    }
}
