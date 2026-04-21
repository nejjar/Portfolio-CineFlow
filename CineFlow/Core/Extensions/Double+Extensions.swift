//
//  Double+Extensions.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import Foundation

extension Double {
    /// Converts TMDB vote average (0–10) to a 0–5 star rating.
    var starRating: Double { (self / 10.0) * 5.0 }

    /// Rounds to one decimal place.
    var oneDecimal: String {
        String(format: "%.1f", self)
    }
}

extension Int {
    /// Formats vote count with K / M suffixes.
    var formattedCount: String {
        switch self {
        case 0..<1_000: return "\(self)"
        case 1_000..<1_000_000: return String(format: "%.1fK", Double(self) / 1_000)
        default: return String(format: "%.1fM", Double(self) / 1_000_000)
        }
    }
}
