//
//  CustomTabBar.swift
//  CineFlow
//
//  Created by Hamza Nejjar on 21/03/2026.
//

import SwiftUI

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    TabBarItem(tab: tab, isSelected: selectedTab == tab)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.cineBorder, lineWidth: 0.5)
                )
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 2)
        .shadow(color: Color.black.opacity(0.3), radius: 20, y: -5)
    }
}

struct TabBarItem: View {
    let tab: AppTab
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(Color.cineAccent.opacity(0.15))
                        .frame(width: 44, height: 32)
                        .matchedGeometryEffect(id: "tabBg", in: tabNamespace)
                }
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: isSelected ? .bold : .regular))
                    .foregroundStyle(isSelected ? Color.cineAccent : Color.cineSubtitle)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
            }
            Text(tab.title)
                .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? Color.cineAccent : Color.cineSubtitle)
        }
        .frame(maxWidth: .infinity)
    }

    @Namespace private var tabNamespace
}
#Preview("Custom Tab Bar - Home") {
    CustomTabBar(selectedTab: .constant(.home))
        .background(Color.cineDark)
}

#Preview("Custom Tab Bar - Search") {
    CustomTabBar(selectedTab: .constant(.search))
        .background(Color.cineDark)
}

#Preview("Custom Tab Bar - Watchlist") {
    CustomTabBar(selectedTab: .constant(.watchlist))
        .background(Color.cineDark)
}

