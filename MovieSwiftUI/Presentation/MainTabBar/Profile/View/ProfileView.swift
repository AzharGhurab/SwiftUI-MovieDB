//
//  ProfileView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Profile Stats

struct ProfileStats: Equatable {
    let favorites: Int
    let watchlist: Int
    let lists: Int
}

// MARK: - Profile View

struct ProfileView: View {

    // MARK: - Properties

    let state: ProfileViewModel.State
    var stats: ProfileStats? = nil
    let onSignIn: () -> Void
    let onLogout: () -> Void
    let onListsTap: () -> Void
    let onFavoritesTap: () -> Void
    let onWatchlistTap: () -> Void
    let onRetry: () -> Void

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                menuCard

                if isSignedIn {
                    logoutCard
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
    }

    // MARK: - State Helpers

    private var isSignedIn: Bool {
        if case .signedIn = state { return true }
        return false
    }

    // MARK: - Header Card

    private var headerCard: some View {
        VStack(spacing: 16) {
            headerContent

            if isSignedIn, let stats {
                Divider()
                statsRow(stats)
            }
        }
        .padding(16)
        .background(cardBackground)
    }

    @ViewBuilder
    private var headerContent: some View {
        switch state {

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)

        case .signedIn(let profile):
            HStack(spacing: 16) {
                avatar(url: profile.avatarURL)

                Text(profile.username)
                    .font(.title3.weight(.semibold))

                Spacer()
            }

        case .guest:
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    avatar(url: nil)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Guest User")
                            .font(.title3.weight(.semibold))

                        Text("Not signed in to TMDB")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                Button(action: onSignIn) {
                    Text("Sign In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
            }

        case .failed(let message):
            VStack(spacing: 8) {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Retry", action: onRetry)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Stats

    private func statsRow(_ stats: ProfileStats) -> some View {
        HStack {
            statItem(value: stats.favorites, title: "Favorites")
            Divider().frame(height: 32)
            statItem(value: stats.watchlist, title: "Watchlist")
            Divider().frame(height: 32)
            statItem(value: stats.lists, title: "Lists")
        }
    }

    private func statItem(value: Int, title: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title3.weight(.semibold))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Avatar

    private func avatar(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            default:
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(Circle())
    }

    // MARK: - Menu Card

    private var menuCard: some View {
        VStack(spacing: 0) {
            menuRow(title: "My Lists", icon: "list.bullet.rectangle", action: onListsTap)
            Divider().padding(.leading, 52)
            menuRow(title: "Favorites", icon: "heart", action: onFavoritesTap)
            Divider().padding(.leading, 52)
            menuRow(title: "Watchlist", icon: "bookmark", action: onWatchlistTap)
        }
        .background(cardBackground)
    }

    private func menuRow(
        title: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 24)

                Text(title)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Logout Card

    private var logoutCard: some View {
        Button(role: .destructive, action: onLogout) {
            HStack(spacing: 16) {
                Image(systemName: "rectangle.portrait.and.arrow.right")                    .font(.title3)
                    .frame(width: 24)

                Text("Sign Out")

                Spacer()
            }
            .foregroundStyle(.red)
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(cardBackground)
    }

    // MARK: - Card Background

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
    }
}

// MARK: - Preview

#Preview("Signed In") {
    NavigationStack {
        ProfileView(
            state: .signedIn(UserProfile(id: 1, username: "azhar", avatarURL: nil)),
            stats: ProfileStats(favorites: 0, watchlist: 0, lists: 0),
            onSignIn: {}, onLogout: {}, onListsTap: {},
            onFavoritesTap: {}, onWatchlistTap: {}, onRetry: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Guest") {
    NavigationStack {
        ProfileView(
            state: .guest,
            onSignIn: {}, onLogout: {}, onListsTap: {},
            onFavoritesTap: {}, onWatchlistTap: {}, onRetry: {}
        )
    }
    .preferredColorScheme(.dark)
}
