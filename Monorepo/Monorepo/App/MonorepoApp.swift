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
        let monoFont = UIFont.monospacedSystemFont(ofSize: 25, weight: .bold)
        let monoInlineFont = UIFont.monospacedSystemFont(ofSize: 17, weight: .semibold)
        
        // Apply to Large and Standard titles
        appearance.largeTitleTextAttributes = [.font: monoFont]
        appearance.titleTextAttributes = [.font: monoInlineFont]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ArcadeHomeView()
                .fontDesign(.monospaced)
        }
    }
}
