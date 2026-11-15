//
//  ProfileFlowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Profile Route

enum ProfileRoute: Hashable {
    case lists
}

// MARK: - Profile Flow View

struct ProfileFlowView: View {

    // MARK: - Properties

    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var path = NavigationPath()

    // MARK: - Sign-in Prompt State

    @State private var isShowingSignInPrompt = false
    @State private var isShowingSafari = false
    @State private var pendingRoute: ProfileRoute?

    private let makeListsFlow: () -> ListsFlowView

    // MARK: - Initialization

    init(
        viewModel: @autoclosure @escaping () -> ProfileViewModel,
        makeListsFlow: @escaping () -> ListsFlowView
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.makeListsFlow = makeListsFlow
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $path) {
            ProfileView(
                state: viewModel.state,
                onSignIn: signIn,
                onLogout: logout,
                onListsTap: openLists,
                onFavoritesTap: { },
                onWatchlistTap: { },
                onRetry: { Task { await viewModel.load() } }
            )
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .lists:
                    makeListsFlow()
                }
            }
        }
        .task {
            await viewModel.load()
        }
        .overlay {
            if isShowingSignInPrompt {
                signInPrompt
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isShowingSignInPrompt)
        .sheet(
            isPresented: $isShowingSafari,
            onDismiss: {
                Task { await authViewModel.completeSignIn() }
            }
        ) {
            if let url = authViewModel.authorizationURL {
                TMDBSafariView(url: url)
            }
        }
        .onChange(of: authViewModel.authState) { _, newState in
            guard newState == .authenticated else { return }
            handleSignedIn()
        }
    }

    // MARK: - Sign-in Prompt

    private var signInPrompt: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    if !authViewModel.isSigningIn {
                        closePrompt()
                    }
                }

            SignInPromptView(
                isLoading: authViewModel.isSigningIn,
                errorMessage: authViewModel.errorMessage,
                onSignIn: startTMDBSignIn,
                onNotNow: closePrompt
            )
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
    }

    // MARK: - Actions

    private func openLists() {
        switch viewModel.state {

        case .signedIn:
            path.append(ProfileRoute.lists)

        case .guest:
            pendingRoute = .lists
            isShowingSignInPrompt = true

        default:
            break
        }
    }

    private func startTMDBSignIn() {
        Task {
            await authViewModel.startTMDBSignIn()

            if authViewModel.authorizationURL != nil {
                isShowingSafari = true
            }
        }
    }

    private func closePrompt() {
        isShowingSignInPrompt = false
        pendingRoute = nil
        authViewModel.errorMessage = nil
    }

    private func handleSignedIn() {
        isShowingSignInPrompt = false

        let route = pendingRoute
        pendingRoute = nil

        Task {
            await viewModel.load()

            if let route {
                path.append(route)
            }
        }
    }

    private func signIn() {
        authViewModel.signOut()
    }

    private func logout() {
        authViewModel.signOut()
    }
}
