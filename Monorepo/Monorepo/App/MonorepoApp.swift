//
//  MonorepoApp.swift
//  Monorepo
//
//  Created by codeAlligator on 30/01/26.
//

import SwiftUI

@main
struct MonorepoApp: App {
    
    init() {
        // Configure the Navigation Bar Appearance globally
        let appearance = UINavigationBarAppearance()
        
        // Define the monospaced font with a specific size
        let monoFont = UIFont(name: "RetroGaming", size: 25) ?? .monospacedSystemFont(ofSize: 25, weight: .bold)
        let monoInlineFont = UIFont(name: "RetroGaming", size: 17) ?? .monospacedSystemFont(ofSize: 17, weight: .bold)
        
        // Apply to Large and Standard titles
        appearance.largeTitleTextAttributes = [.font: monoFont]
        appearance.titleTextAttributes = [.font: monoInlineFont]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ArcadeHomeView()
                .font(.retroGameLargeTitle)
        }
    }
}
