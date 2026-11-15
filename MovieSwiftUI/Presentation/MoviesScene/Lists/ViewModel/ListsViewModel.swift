//
//  ListsViewModel.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation
import Combine

// MARK: - Lists ViewModel

@MainActor
final class ListsViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case loading
        case loaded([UserList])
        case failed(String)
    }

    @Published private(set) var state: State = .loading

    // MARK: - Delete State

    @Published var listPendingDeletion: UserList?
    @Published private(set) var isDeleting = false
    @Published var deleteErrorMessage: String?

    // MARK: - Dependencies

    private let fetchUserListsUseCase: any FetchUserListsUseCase
    private let deleteListUseCase: any DeleteListUseCase
    private let sessionIDProvider: () -> String?

    // MARK: - Initialization

    init(
        fetchUserListsUseCase: any FetchUserListsUseCase,
        deleteListUseCase: any DeleteListUseCase,
        sessionIDProvider: @escaping () -> String? = {
            KeychainManager.shared.read(for: .sessionId)
        }
    ) {
        self.fetchUserListsUseCase = fetchUserListsUseCase
        self.deleteListUseCase = deleteListUseCase
        self.sessionIDProvider = sessionIDProvider
    }

    // MARK: - Load

    func load() async {
        guard let sessionID = sessionIDProvider(),
              !sessionID.isEmpty else {
            state = .failed("Please sign in to your TMDB account.")
            return
        }

        if case .loaded = state {
        } else {
            state = .loading
        }

        do {
            let lists = try await fetchUserListsUseCase.execute(
                sessionID: sessionID
            )
            state = .loaded(lists)
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    // MARK: - Delete

    func requestDelete(_ list: UserList) {
        listPendingDeletion = list
    }

    func cancelDelete() {
        listPendingDeletion = nil
    }

    func confirmDelete() async {
        guard let list = listPendingDeletion else { return }

        guard let sessionID = sessionIDProvider(),
              !sessionID.isEmpty else {
            deleteErrorMessage = "Please sign in to your TMDB account."
            listPendingDeletion = nil
            return
        }

        isDeleting = true
        defer { isDeleting = false }

        do {
            try await deleteListUseCase.execute(
                listID: list.id,
                sessionID: sessionID
            )

            if case .loaded(let lists) = state {
                state = .loaded(lists.filter { $0.id != list.id })
            }

            listPendingDeletion = nil
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            deleteErrorMessage = error.localizedDescription
            listPendingDeletion = nil
        }
    }
}
