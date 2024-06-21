//
//  ContentView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var nav: NavigationManager
    @Query(sort: [SortDescriptor(\LastlyTag.title)]) private var tags: [LastlyTag]
    @State private var newTitle = ""
    
    var body: some View {

        List(selection: $nav.currentTasks) {
            InboxView()
            
            ForEach(tags) { tag in
                TagListView(tag: tag)
            }
        }
    }
}

#Preview(traits: .sampleData) {
    let nav = NavigationManager()
    
    HomeView()
        .environmentObject(nav)
}
