//
//  ListsView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Lists View

struct ListsView: View {

    // MARK: - Properties

    let state: ListsViewModel.State
    let onRetry: () -> Void
    let onDeleteRequest: (UserList) -> Void

    // MARK: - Body

    var body: some View {
        Group {
            switch state {
                
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded(let lists):
                if lists.isEmpty {
                    emptyView
                } else {
                    listView(lists)
                }
                
            case .failed(let message):
                ContentUnavailableView {
                    Label("Something went wrong", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Retry", action: onRetry)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .environment(\.colorScheme, .dark)
        .navigationTitle("My Lists")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: ListsRoute.create) {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - List

    private func listView(_ lists: [UserList]) -> some View {
        List(lists) { list in
            NavigationLink(value: list) {
                ListRowView(list: list)
            }
            .listRowBackground(Color.black)
            .listRowSeparator(.hidden, edges: .top)
            .listRowSeparatorTint(Color.white.opacity(0.15))
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                    onDeleteRequest(list)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    // MARK: - Empty

    private var emptyView: some View {
        ContentUnavailableView {
            Label("No Lists Yet", systemImage: "list.bullet.rectangle")
        } description: {
            Text("Tap + to create your first list.")
        } actions: {
            NavigationLink("Create List", value: ListsRoute.create)
        }
    }
}

// MARK: - Preview

#Preview("Loaded") {
    NavigationStack {
        ListsView(
            state: .loaded([
                UserList(id: 1, name: "kenan", description: "", itemCount: 0, posterPath: nil, updatedAt: nil),
                UserList(id: 2, name: "azhar", description: "Test", itemCount: 0, posterPath: nil, updatedAt: nil)
            ]),
            onRetry: {},
            onDeleteRequest: { _ in }
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        ListsView(state: .loaded([]), onRetry: {}, onDeleteRequest: { _ in })
    }
}
