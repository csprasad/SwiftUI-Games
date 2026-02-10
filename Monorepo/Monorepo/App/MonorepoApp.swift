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
        runFontTest() 
        // Configure the Navigation Bar Appearance globally
        let appearance = UINavigationBarAppearance()
        
        // Define the monospaced font with a specific size
        let monoFont = UIFont(name: "BungeeSpice-Regular", size: 25) ?? .monospacedSystemFont(ofSize: 25, weight: .bold)
        let monoInlineFont = UIFont(name: "BungeeSpice-Regular", size: 17) ?? .monospacedSystemFont(ofSize: 17, weight: .bold)
        
        // Apply to Large and Standard titles
        appearance.largeTitleTextAttributes = [.font: monoFont]
        appearance.titleTextAttributes = [.font: monoInlineFont]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ArcadeHomeView()
                .font(.bungeeSpiceLargeTitle)
        }
    }
    
    func runFontTest() {
        for family in UIFont.familyNames {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  \(name)")
            }
        }
    }
}
