//
//  SearchView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Search View

struct SearchView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: SearchViewModel

    @FocusState private var isSearchFocused: Bool

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            searchBar

            sectionTitle("Genres")

            mediaTypeTabs

            GenreFilterView(
                genres: viewModel.genres,
                selectedGenre: viewModel.selectedGenre
            ) { genre in
                viewModel.select(genre: genre)
            }

            sectionTitle(resultsTitle)

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .foregroundStyle(.white)
        .preferredColorScheme(.dark)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task(id: viewModel.trigger) {
            await viewModel.search()
        }
        .task(id: viewModel.mediaType) {
            await viewModel.loadGenres()
        }
    }

    // MARK: - Results Title

    private var resultsTitle: String {
        viewModel.trigger.query.isEmpty ? "Popular" : "Results"
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.5))

            TextField(
                "Search movies, TV shows...",
                text: $viewModel.query
            )
            .focused($isSearchFocused)
            .submitLabel(.search)
            .autocorrectionDisabled()

            if !viewModel.query.isEmpty {
                Button {
                    viewModel.query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.4))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Capsule().fill(Color.white.opacity(0.08)))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Section Title

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 19, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 4)
    }

    // MARK: - Media Type Tabs

    private var mediaTypeTabs: some View {
        HStack(spacing: 0) {
            ForEach(MediaType.allCases, id: \.self) { type in
                let isSelected = viewModel.mediaType == type

                Button {
                    viewModel.select(mediaType: type)
                } label: {
                    Text(type.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(
                            isSelected ? AppTheme.accent : Color.white.opacity(0.5)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(alignment: .bottom) {
                            if isSelected {
                                Capsule()
                                    .fill(AppTheme.accent)
                                    .frame(width: 90, height: 3)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .overlay(alignment: .bottom) {
            Divider().overlay(Color.white.opacity(0.08))
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.results.isEmpty && viewModel.isLoading {
            skeletonList

        } else if viewModel.results.isEmpty,
                  let message = viewModel.errorMessage {
            errorView(message)

        } else {
            list
        }
    }

    // MARK: - Skeleton

    private var skeletonList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(0..<8, id: \.self) { _ in
                    MovieRowSkeletonView()
                        .padding(.vertical, 10)

                    Divider()
                        .overlay(Color.white.opacity(0.08))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .scrollDisabled(true)
    }

    // MARK: - List

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredResults) { movie in
                    row(for: movie)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreIfNeeded(currentItem: movie)
                            }
                        }

                    Divider()
                        .overlay(Color.white.opacity(0.08))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .padding()
            }

            if let message = viewModel.errorMessage {
                errorView(message)
                    .padding()
            }

            if viewModel.filteredResults.isEmpty && !viewModel.isLoading
                && viewModel.errorMessage == nil {
                emptyView
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Row

    @ViewBuilder
    private func row(for movie: MovieSummary) -> some View {
        if movie.mediaType == .movie {
            NavigationLink(value: movie) {
                SearchResultRowView(movie: movie, showsChevron: true)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
        } else {
            SearchResultRowView(movie: movie, showsChevron: false)
                .padding(.vertical, 10)
        }
    }

    // MARK: - Empty

    @ViewBuilder
    private var emptyView: some View {
        if viewModel.trigger.query.isEmpty {
            ContentUnavailableView(
                "No Results",
                systemImage: "film",
                description: Text("Try another genre.")
            )
        } else {
            ContentUnavailableView.search(text: viewModel.trigger.query)
        }
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.retry() }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}
