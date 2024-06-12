//
//  InboxView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI
import SwiftData

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

#Preview(traits: .sampleData) {
    let nav = NavigationManager()
    
    InboxView()
        .environmentObject(nav)
}
