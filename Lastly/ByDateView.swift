//
//  ByDateView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI
import SwiftData

struct ByDateView: View {
    
    @Query private var tasks: [LastlyTask]
    
    var body: some View {
        TaskListView(tasks: tasks)
    }
}

#Preview(traits: .sampleData) {
    let nav = NavigationManager()
        
    ByDateView()
        .environmentObject(nav)
}
