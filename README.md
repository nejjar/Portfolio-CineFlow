# CineFlow

A sophisticated iOS app to discover movies and TV series powered by TMDB.

## Architecture

```
Clean Architecture + MVVM-C
├── Domain Layer      — Entities, Repository protocols, Use Cases
├── Data Layer        — API client, DTOs, Repository implementations, SwiftData
└── Presentation      — Coordinators, ViewModels, SwiftUI Views
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI |
| Concurrency | Swift Concurrency (async/await, Task, actor) |
| Architecture | Clean Architecture + MVVM-C |
| Persistence | SwiftData |
| Unit Tests | XCTest |
| UI Tests | XCUITest |
| Minimum iOS | iOS 17+ |

## Features

- **Home** — Auto-advancing featured banner + horizontal category rows
- **Movies** — Now Playing, Popular, Top Rated, Upcoming with infinite scroll grid
- **Series** — On The Air, Popular, Top Rated
- **Detail** — Parallax backdrop, cast carousel, similar titles, watchlist toggle
- **Search** — Debounced real-time search with Movies/Series segmented filter
- **Watchlist** — Persisted with SwiftData, filterable by media type

## Setup

### 1. Create Xcode Project

1. Open **Xcode** → New Project → **iOS App**
2. Product Name: `CineFlow`
3. Bundle Identifier: `com.yourname.CineFlow`
4. Interface: **SwiftUI**, Language: **Swift**
5. **Check** "Include Tests" (creates unit + UI test targets)

### 2. Add Source Files

Drag the `CineFlow/` folder into Xcode's project navigator:
- Ensure **"Copy items if needed"** is NOT checked (files are already in place)
- Add to target: `CineFlow`

Drag the `CineFlowTests/` files into the **CineFlowTests** target.
Drag the `CineFlowUITests/` files into the **CineFlowUITests** target.

### 3. Configure SwiftData

In the app target settings, SwiftData requires **iOS 17+**:
- General → Deployment Info → iOS **17.0**

### 4. Get a TMDB API Key

1. Create a free account at [themoviedb.org](https://www.themoviedb.org/signup)
2. Go to **Settings → API** and request an API key
3. Open `Core/Constants/AppConstants.swift` and replace:

```swift
static let tmdbAPIKey = "YOUR_TMDB_API_KEY"
```

### 5. Run

Select an iPhone 17+ simulator and press **⌘R**.

## Project Structure

```
CineFlow/
├── CineFlowApp.swift              — App entry point + SwiftData container
├── Core/
│   ├── Constants/AppConstants.swift
│   ├── Extensions/               — Color, View, String, Double helpers
│   └── DI/DependencyContainer.swift
├── Domain/
│   ├── Entities/                 — Movie, TVShow, Genre, CastMember, MediaVideo
│   ├── Repositories/             — Protocol definitions
│   └── UseCases/                 — Business logic
├── Data/
│   ├── Network/                  — APIClient, Endpoints, NetworkError
│   ├── DTOs/                     — Decodable structs + toDomain() mapping
│   ├── Repositories/             — Concrete implementations
│   └── Persistence/WatchlistItem.swift  — @Model SwiftData entity
└── Presentation/
    ├── Coordinators/             — AppCoordinator (NavigationPath) + Routes
    ├── ViewModels/               — @MainActor ObservableObject VMs
    └── Views/
        ├── Home/                 — HomeView, FeaturedBanner, MediaRows, Tabs
        ├── Detail/               — Movie + TVShow detail with parallax
        ├── Search/               — Debounced search + segmented results
        ├── Watchlist/            — SwiftData-backed saved list
        └── Components/           — Reusable cards, badges, shimmer, tab bar

CineFlowTests/
├── Mocks/                        — MockMovieRepository, MockTVShowRepository
├── UseCases/                     — FetchTrendingUseCaseTests, SearchUseCaseTests
└── ViewModels/                   — HomeViewModelTests, SearchViewModelTests + more

CineFlowUITests/
└── CineFlowUITests.swift         — Tab navigation, search, watchlist, performance
```

## Design System

| Token | Value |
|-------|-------|
| Background | `#0D0D0D` |
| Card surface | `#1A1A2E` |
| Accent | `#E94560` |
| Rating gold | `#F5A623` |
| Subtitle | `#8A8A9A` |

Animations use **spring(response:dampingFraction:)** throughout with staggered
`fadeInOnAppear` for list items, parallax scroll on detail backdrop, and a
shimmer placeholder during loading.
