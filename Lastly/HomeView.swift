//
//  ContentView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import SwiftUI
import SwiftData

struct TaskRowView: View {
    var task: LastlyTask
    
    var body: some View {
        HStack {
            Text(task.title)
            
            Spacer()
            
            if let first = task.completions.sorted().last {
                Text(Date.now, format: .reference(to: first, allowedFields: [.day, .minute,. hour, .month], thresholdField: .month))
            }
        }
    }
}

struct InboxView: View {
    
    @Query(filter: #Predicate<LastlyTask> { $0.tags.isEmpty }) private var tasks: [LastlyTask]
    
    var body: some View {
        Section("Inbox") {
            ForEach(tasks) { lTask in
                TaskRowView(task: lTask)
            }
        }
    }
}

struct SearchView: View {
    
    @State var query: String = ""
    @Query private var tasks: [LastlyTask]
    
    var searched: [LastlyTask] {
        return tasks.sorted().reversed().filter {
            query.isEmpty || $0.title
                .localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        List {
            if searched.isEmpty {
                ContentUnavailableView(
                    "No results found",
                    systemImage: "doc.text.magnifyingglass"
                )
            } else {
                
                ForEach(searched) { lTask in
                    TaskRowView(task: lTask)
                }
            }
        }
        .searchable(text: $query)
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        SearchView()
    }
}

struct ByDateView: View {
    
    @Query private var tasks: [LastlyTask]
    
    var body: some View {
        ForEach(tasks.sorted().reversed()) { lTask in
            TaskRowView(task: lTask)
        }
    }
}

#Preview(traits: .sampleData) {
    ByDateView()
}

struct TagListView: View {
    
    var tag: LastlyTag
    var body: some View {
        Section(tag.title) {
            if tag.tasks.isEmpty {
                ContentUnavailableView("No tasks!", systemImage: "highlighter", description: Text("Add some tasks using the **Add Bar**!"))
            } else {
                ForEach(tag.tasks.sorted()) { lTask in
                    TaskRowView(task: lTask)
                }
            }
        }
    }
}

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
    HomeView()
}
