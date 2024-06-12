//
//  TagListView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI
import SwiftData

struct TagListView: View {
    
    var tag: LastlyTag
    
    var body: some View {
        Section(tag.title) {
            if tag.tasks.isEmpty {
                ContentUnavailableView("No tasks!", systemImage: "highlighter", description: Text("Add some tasks using the **Add Bar**!"))
            } else {
                TaskListView(tasks: tag.tasks.sorted())
            }
        }
    }
}

#Preview(traits: .sampleData) {
    let nav = NavigationManager()
    
    TagListView(tag: LastlyTag(title: "Testing"))
        .environmentObject(nav)
}
