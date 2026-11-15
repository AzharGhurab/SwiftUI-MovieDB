//
//  ListDetailsFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 04/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - List Details Flow View

struct ListDetailsFlowView: View {

    // MARK: - Properties

    @StateObject private var viewModel: ListDetailsViewModel

    // MARK: - Initialization

    init(viewModel: @autoclosure @escaping () -> ListDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    // MARK: - Body

    var body: some View {
        ListDetailsView(
            title: viewModel.list.name,
            state: viewModel.state,
            onRetry: { Task { await viewModel.load() } }
        )
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
    }
}
