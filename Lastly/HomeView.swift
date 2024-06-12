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
    @Query(sort: [SortDescriptor(\LastlyTag.title)]) private var tags: [LastlyTag]
    @State private var newTitle = ""
    
    var body: some View {

        List {
            InboxView()
            
            ForEach(tags) { lTag in
                TagListView(tag: lTag)
            }
        }
    }
}

#Preview(traits: .sampleData) {
    let nav = NavigationManager()
    
    HomeView()
        .environmentObject(nav)
}
