//
//  Color+Extensions.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

extension Color {
    // MARK: - Brand Colors
    static let brandBackground = Color("BrandBackground", bundle: nil)
    static let brandSurface = Color("BrandSurface", bundle: nil)
    static let brandAccent = Color("BrandAccent", bundle: nil)
    static let brandSecondary = Color("BrandSecondary", bundle: nil)
    static let brandGold = Color("BrandGold", bundle: nil)

    // MARK: - Semantic Palette (fallbacks for previews)
    static let cineDark = Color(hex: "#0D0D0D")
    static let cineCard = Color(hex: "#1A1A2E")
    static let cineSurface = Color(hex: "#16213E")
    static let cineAccent = Color(hex: "#E94560")
    static let cineGold = Color(hex: "#F5A623")
    static let cineGlass = Color(hex: "#FFFFFF").opacity(0.08)
    static let cineBorder = Color(hex: "#FFFFFF").opacity(0.12)
    static let cineSubtitle = Color(hex: "#8A8A9A")

    // MARK: - Init from Hex
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    // MARK: - Gradient Helpers
    static var accentGradient: LinearGradient {
        LinearGradient(
            colors: [Color.cineAccent, Color(hex: "#C2185B")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [Color.cineCard, Color.cineSurface],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var heroOverlayGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.cineDark.opacity(0),
                Color.cineDark.opacity(0.4),
                Color.cineDark.opacity(0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
