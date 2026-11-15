//
//  ListsDIContainer.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Lists DI Container

@MainActor
final class ListsDIContainer {

    // MARK: - Repository

    private lazy var accountRepository: any AccountRepository =
        DefaultAccountRepository()

    // MARK: - Use Cases

    private func makeFetchUserListsUseCase() -> any FetchUserListsUseCase {
        DefaultFetchUserListsUseCase(
            repository: accountRepository
        )
    }

    private func makeCreateListUseCase() -> any CreateListUseCase {
        DefaultCreateListUseCase(
            repository: accountRepository
        )
    }
    private func makeDeleteListUseCase() -> any DeleteListUseCase {
        DefaultDeleteListUseCase(
            repository: accountRepository
        )
    }
    private func makeFetchListDetailsUseCase() -> any FetchListDetailsUseCase {
        DefaultFetchListDetailsUseCase(
            repository: accountRepository
        )
    }

    // MARK: - ViewModels

    func makeListsViewModel() -> ListsViewModel {
        ListsViewModel(
            fetchUserListsUseCase: makeFetchUserListsUseCase(),
            deleteListUseCase: makeDeleteListUseCase()
        )
    }

    func makeCreateListViewModel() -> CreateListViewModel {
        CreateListViewModel(
            createListUseCase: makeCreateListUseCase()
        )
    }
    func makeListDetailsViewModel(list: UserList) -> ListDetailsViewModel {
        ListDetailsViewModel(
            list: list,
            fetchListDetailsUseCase: makeFetchListDetailsUseCase()
        )
    }

    // MARK: - Flows

    func makeListsFlowView() -> ListsFlowView {
        ListsFlowView(
            viewModel: self.makeListsViewModel(),
            makeCreateListFlow: { [self] onCreated in
                self.makeCreateListFlowView(onCreated: onCreated)
            },
            makeListDetailsFlow: { [self] list in
                self.makeListDetailsFlowView(list: list)
            }
        )
    }

    func makeCreateListFlowView(
        onCreated: @escaping () -> Void
    ) -> CreateListFlowView {
        CreateListFlowView(
            viewModel: self.makeCreateListViewModel(),
            onCreated: onCreated
        )
    }
    func makeListDetailsFlowView(list: UserList) -> ListDetailsFlowView {
        ListDetailsFlowView(
            viewModel: self.makeListDetailsViewModel(list: list)
        )
    }
}
