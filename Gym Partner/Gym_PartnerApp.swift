//
//  Gym_PartnerApp.swift
//  Gym Partner
//
//  Created by Shashiraj Walsetwar on 11/16/24.
//

import SwiftUI
import SwiftData

@main
struct Gym_PartnerApp: App {
    // SwiftData ModelContainer
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self, // Register our Item model in the schema
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer) // Provide the ModelContainer to the entire app
    }
}

