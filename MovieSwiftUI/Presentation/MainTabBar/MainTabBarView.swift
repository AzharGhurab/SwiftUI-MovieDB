//
//  MainTabBarView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import SwiftUI

// MARK: - Main Tab Bar View

struct MainTabBarView: View {

    // MARK: - Dependencies

    @State private var homeContainer = HomeDIContainer()
    @State private var searchContainer = SearchDIContainer()
    @State private var profileContainer = ProfileDIContainer()

    // MARK: - Body

    var body: some View {
        TabView {

            // MARK: - Home Tab

            homeContainer.makeHomeFlowView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            // MARK: - Search Tab

            searchContainer.makeSearchFlowView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            // MARK: - Profile Tab

            profileContainer.makeProfileFlowView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(AppTheme.accent)
    }
}
