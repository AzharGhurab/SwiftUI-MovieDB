//
//  SearchFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Search Flow View

struct SearchFlowView: View {

    // MARK: - Dependencies

    @StateObject private var viewModel: SearchViewModel

    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
    private let fetchAccountStatesUseCase: any FetchMovieAccountStatesUseCase
    private let updateMovieAccountUseCase: any UpdateMovieAccountUseCase


    private let sessionIDProvider: () -> String?

    // MARK: - Initialization

    init(
        viewModel: @autoclosure @escaping () -> SearchViewModel,
        fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase,
        fetchAccountStatesUseCase: any FetchMovieAccountStatesUseCase,
        updateMovieAccountUseCase: any UpdateMovieAccountUseCase,
        sessionIDProvider: @escaping () -> String?
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())

        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchAccountStatesUseCase = fetchAccountStatesUseCase
        self.updateMovieAccountUseCase = updateMovieAccountUseCase
        self.sessionIDProvider = sessionIDProvider
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            SearchView(viewModel: viewModel)
                .navigationDestination(for: MovieSummary.self) { movie in
                    MovieDetailsFlowView(
                        movieID: movie.id,
                        fetchMovieDetailsUseCase: fetchMovieDetailsUseCase,
                        fetchAccountStatesUseCase: fetchAccountStatesUseCase,
                        updateMovieAccountUseCase: updateMovieAccountUseCase,
                        sessionID: sessionIDProvider()
                    )
                }
        }
    }
}
