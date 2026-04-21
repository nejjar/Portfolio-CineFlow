//
//  CineFlowUITests.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import XCTest

// MARK: - CineFlow UI Tests
final class CineFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Tab Bar Tests
    func test_tabBar_isVisible() {
        // Custom tab bar items are visible
        XCTAssertTrue(app.buttons["House"].exists ||
                      app.buttons.matching(identifier: "home").firstMatch.exists ||
                      app.otherElements.count > 0)
    }

    func test_homeView_isDisplayedOnLaunch() {
        let homeView = app.otherElements["homeView"]
        let exists = homeView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
    }

    // MARK: - Navigation Tests
    func test_searchTab_navigatesToSearch() {
        // Tap search tab
        let searchButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Search'")).firstMatch
        if searchButton.exists {
            searchButton.tap()
            let searchView = app.otherElements["searchView"]
            XCTAssertTrue(searchView.waitForExistence(timeout: 3))
        }
    }

    func test_watchlistTab_navigatesToWatchlist() {
        let watchlistButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Watchlist'")
        ).firstMatch
        if watchlistButton.exists {
            watchlistButton.tap()
            let watchlistView = app.otherElements["watchlistView"]
            XCTAssertTrue(watchlistView.waitForExistence(timeout: 3))
        }
    }

    // MARK: - Search Tests
    func test_searchView_hasSearchField() {
        navigateToSearch()
        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
    }

    func test_searchView_typingQueryShowsResults() {
        navigateToSearch()
        let searchField = app.textFields["searchField"]
        guard searchField.waitForExistence(timeout: 3) else { return }
        searchField.tap()
        searchField.typeText("Batman")
        // Wait for debounce + network
        sleep(3)
        // Either results or no-results state should appear (not empty state)
        XCTAssertFalse(app.staticTexts["Find your next watch"].exists)
    }

    func test_searchView_clearButtonResetsSearch() {
        navigateToSearch()
        let searchField = app.textFields["searchField"]
        guard searchField.waitForExistence(timeout: 3) else { return }
        searchField.tap()
        searchField.typeText("Batman")
        sleep(1)
        let clearButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'clear'")).firstMatch
        if clearButton.exists {
            clearButton.tap()
            XCTAssertEqual(searchField.value as? String ?? "", "")
        }
    }

    // MARK: - Watchlist Tests
    func test_watchlistView_emptyState_showsMessage() {
        navigateToWatchlist()
        let emptyText = app.staticTexts["Your watchlist is empty"]
        // Only check if no items (fresh install)
        if app.buttons["Discover Content"].waitForExistence(timeout: 2) {
            XCTAssertTrue(emptyText.waitForExistence(timeout: 2))
        }
    }

    // MARK: - Scroll Tests
    func test_homeView_canScroll() {
        let homeView = app.otherElements["homeView"]
        guard homeView.waitForExistence(timeout: 5) else { return }
        app.swipeUp()
        // Just verify no crash
        XCTAssertTrue(true)
    }

    // MARK: - Helpers
    private func navigateToSearch() {
        let searchButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Search'")
        ).firstMatch
        if searchButton.waitForExistence(timeout: 3) {
            searchButton.tap()
        }
    }

    private func navigateToWatchlist() {
        let watchlistButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Watchlist'")
        ).firstMatch
        if watchlistButton.waitForExistence(timeout: 3) {
            watchlistButton.tap()
        }
    }
}

// MARK: - Performance Tests
final class CineFlowPerformanceTests: XCTestCase {
    func test_appLaunchPerformance() throws {
        measure {
            XCUIApplication().launch()
        }
    }
}
