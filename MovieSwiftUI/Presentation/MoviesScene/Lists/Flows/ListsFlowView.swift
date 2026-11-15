//
//  ListsFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Lists Route

enum ListsRoute: Hashable {
    case create
}

// MARK: - Lists Flow View

struct ListsFlowView: View {

    // MARK: - Properties

    @StateObject private var viewModel: ListsViewModel

    private let makeCreateListFlow: (@escaping () -> Void) -> CreateListFlowView
    private let makeListDetailsFlow: (UserList) -> ListDetailsFlowView

    // MARK: - Initialization

    init(
        viewModel: @autoclosure @escaping () -> ListsViewModel,
        makeCreateListFlow: @escaping (@escaping () -> Void) -> CreateListFlowView,
        makeListDetailsFlow: @escaping (UserList) -> ListDetailsFlowView
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.makeCreateListFlow = makeCreateListFlow
        self.makeListDetailsFlow = makeListDetailsFlow
    }

    // MARK: - Body

    var body: some View {
        ListsView(
            state: viewModel.state,
            onRetry: { Task { await viewModel.load() } },
            onDeleteRequest: { viewModel.requestDelete($0) }
        )
        .navigationDestination(for: ListsRoute.self) { route in
            switch route {
            case .create:
                makeCreateListFlow {
                    Task { await viewModel.load() }
                }
            }
        }
        .navigationDestination(for: UserList.self) { list in
            makeListDetailsFlow(list)
        }
        .overlay {
            if let list = viewModel.listPendingDeletion {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            if !viewModel.isDeleting {
                                viewModel.cancelDelete()
                            }
                        }

                    DeleteListConfirmationView(
                        listName: list.name,
                        isDeleting: viewModel.isDeleting,
                        onConfirm: { Task { await viewModel.confirmDelete() } },
                        onCancel: { viewModel.cancelDelete() }
                    )
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.listPendingDeletion)
        .alert(
            "Couldn't delete list",
            isPresented: Binding(
                get: { viewModel.deleteErrorMessage != nil },
                set: { if !$0 { viewModel.deleteErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.deleteErrorMessage ?? "")
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
    }
}
