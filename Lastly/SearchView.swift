//
//  SearchView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @State var query: String = ""
    @Query private var tasks: [LastlyTask]
    @EnvironmentObject var nav: NavigationManager
    
    var searched: [LastlyTask] {
        return tasks.sorted().reversed().filter {
            query.isEmpty || $0.title
                .localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        Group {
            if searched.isEmpty {
                ContentUnavailableView(
                    "No results found",
                    systemImage: "doc.text.magnifyingglass"
                )
            } else {
                List(selection: $nav.currentTasks) {
                    TaskListView(tasks: searched, showAdd: false)
                }
            }
        }
        .searchable(text: $query)
    }
}

#Preview(traits: .sampleData) {
    
    let nav = NavigationManager()
    
    NavigationStack {
        SearchView()
    }
    .environmentObject(nav)
}
