//
//  CineFlowApp.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI
import SwiftData

@main
struct CineFlowApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: WatchlistItem.self)
        }
    }
}
