//
//  ProfileDIContainer.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Profile DI Container

@MainActor
final class ProfileDIContainer {

    // MARK: - Dependencies

    private let listsContainer = ListsDIContainer()

    // MARK: - Repository

    private lazy var accountRepository: any AccountRepository =
        DefaultAccountRepository()

    // MARK: - Use Cases

    private func makeFetchUserProfileUseCase() -> any FetchUserProfileUseCase {
        DefaultFetchUserProfileUseCase(
            repository: accountRepository
        )
    }

    // MARK: - ViewModel

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            fetchUserProfileUseCase: makeFetchUserProfileUseCase()
        )
    }

    // MARK: - Flow

    func makeProfileFlowView() -> some View {
        ProfileFlowView(
            viewModel: self.makeProfileViewModel(),
            makeListsFlow: { [listsContainer] in
                listsContainer.makeListsFlowView()
            }
        )
    }
}
