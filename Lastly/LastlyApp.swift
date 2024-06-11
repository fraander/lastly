//
//  LastlyApp.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import SwiftUI
import SwiftData

@main
struct LastlyApp: App {
    
    @StateObject var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .modelContainer(for: [LastlyTask.self])
        }
    }
}
