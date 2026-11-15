//
//  SearchViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

// MARK: - Search ViewModel

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Trigger

    struct Trigger: Hashable {
        let query: String
        let mediaType: MediaType
    }

    // MARK: - Published Properties

    @Published var query = ""
    @Published private(set) var mediaType: MediaType = .movie
    @Published private(set) var selectedGenre: GenreFilter?
    @Published private(set) var results: [MovieSummary] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasMorePages = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var genresByType: [MediaType: [GenreFilter]] = [:]

    // MARK: - Dependencies

    private let searchMoviesUseCase: any SearchMoviesUseCase
    private let fetchGenresUseCase: any FetchGenresUseCase

    // MARK: - Pagination

    private var currentPage = 0
    private var generation = 0

    private let debounce: Duration = .milliseconds(400)
    private let minimumVisibleCount = 9
    private let maxFillAttempts = 3

    // MARK: - Initialization

    init(
        searchMovies: any SearchMoviesUseCase,
        fetchGenres: any FetchGenresUseCase
    ) {
        self.searchMoviesUseCase = searchMovies
        self.fetchGenresUseCase = fetchGenres
    }

    // MARK: - Derived State

    var trigger: Trigger {
        Trigger(
            query: query.trimmingCharacters(in: .whitespacesAndNewlines),
            mediaType: mediaType
        )
    }

    var genres: [GenreFilter] {
        genresByType[mediaType] ?? []
    }

    var filteredResults: [MovieSummary] {
        guard let genre = selectedGenre else { return results }
        return results.filter { $0.genreIds.contains(genre.id) }
    }

    // MARK: - Category

    func select(mediaType newType: MediaType) {
        guard newType != mediaType else { return }

        mediaType = newType
        selectedGenre = nil
        results = []
        errorMessage = nil
        hasMorePages = false
    }

    // MARK: - Genres

    func select(genre: GenreFilter?) {
        selectedGenre = genre

        Task { await fillIfNeeded() }
    }

    func loadGenres() async {
        let type = mediaType
        guard genresByType[type] == nil else { return }

        do {
            genresByType[type] = try await fetchGenresUseCase.execute(mediaType: type)
        } catch is CancellationError {
        } catch let error as URLError where error.code == .cancelled {
        } catch {
        }
    }

    // MARK: - Search


    func search() async {
        generation += 1
        currentPage = 0
        hasMorePages = false

        if !trigger.query.isEmpty {
            do {
                try await Task.sleep(for: debounce)
            } catch {
                return
            }
        }

        await load(page: 1, replacing: true)
        await fillIfNeeded()
    }

    func retry() async {
        generation += 1
        currentPage = 0
        await load(page: 1, replacing: true)
    }

    // MARK: - Pagination

    func loadMoreIfNeeded(currentItem movie: MovieSummary) async {
        guard !isLoading, hasMorePages else { return }
        guard filteredResults.suffix(6).contains(where: { $0.id == movie.id }) else { return }

        await load(page: currentPage + 1, replacing: false)
    }

    // MARK: - Loading

    private func load(page: Int, replacing: Bool) async {
        let token = generation
        let currentQuery = trigger.query
        let currentType = mediaType

        isLoading = true
        errorMessage = nil

        defer {
            if token == generation { isLoading = false }
        }

        do {
            let result = try await searchMoviesUseCase.execute(
                query: currentQuery,
                mediaType: currentType,
                page: page
            )

            guard token == generation else { return }

            if replacing {
                results = result.movies
            } else {
                let existingIDs = Set(results.map(\.id))
                results += result.movies.filter { !existingIDs.contains($0.id) }
            }

            currentPage = result.page
            hasMorePages = result.page < result.totalPages

        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            guard token == generation else { return }
            errorMessage = error.localizedDescription
        }
    }

    private func fillIfNeeded() async {
        var attempts = 0

        while selectedGenre != nil,
              filteredResults.count < minimumVisibleCount,
              hasMorePages,
              errorMessage == nil,
              attempts < maxFillAttempts {

            let pageBefore = currentPage
            await load(page: currentPage + 1, replacing: false)

            if currentPage == pageBefore { break }
            attempts += 1
        }
    }
}
