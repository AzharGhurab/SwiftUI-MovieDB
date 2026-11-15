//
//  SearchDIContainer.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Search Dependency Injection Container

@MainActor
final class SearchDIContainer {

    // MARK: - Dependencies

    private let searchRepository: any SearchRepository
    private let genreRepository: any GenreRepository
    private let detailsRepository: any MovieDetailsRepository
    private let accountRepository: any AccountRepository

    // MARK: - Initialization

    init(
        searchRepository: any SearchRepository = DefaultSearchRepository(),
        genreRepository: any GenreRepository = DefaultGenreRepository(),
        detailsRepository: any MovieDetailsRepository = DefaultMovieDetailsRepository(),
        accountRepository: any AccountRepository = DefaultAccountRepository()
    ) {
        self.searchRepository = searchRepository
        self.genreRepository = genreRepository
        self.detailsRepository = detailsRepository
        self.accountRepository = accountRepository
    }

    // MARK: - Use Cases

    func makeSearchMoviesUseCase() -> any SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(repository: searchRepository)
    }

    func makeFetchGenresUseCase() -> any FetchGenresUseCase {
        DefaultFetchGenresUseCase(repository: genreRepository)
    }

    func makeFetchMovieDetailsUseCase() -> any FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(repository: detailsRepository)
    }

    func makeFetchMovieAccountStatesUseCase() -> any FetchMovieAccountStatesUseCase {
        DefaultFetchMovieAccountStatesUseCase(repository: accountRepository)
    }

    func makeUpdateMovieAccountUseCase() -> any UpdateMovieAccountUseCase {
        DefaultUpdateMovieAccountUseCase(repository: accountRepository)
    }

    // MARK: - ViewModel

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            searchMovies: makeSearchMoviesUseCase(),
            fetchGenres: makeFetchGenresUseCase()
        )
    }

    // MARK: - Search Flow

    func makeSearchFlowView() -> SearchFlowView {
        SearchFlowView(
            viewModel: self.makeSearchViewModel(),
            fetchMovieDetailsUseCase: makeFetchMovieDetailsUseCase(),
            fetchAccountStatesUseCase: makeFetchMovieAccountStatesUseCase(),
            updateMovieAccountUseCase: makeUpdateMovieAccountUseCase(),
            sessionIDProvider: {
                KeychainManager.shared.read(for: .sessionId)
            }
        )
    }
}
