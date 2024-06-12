//
//  TaskListView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    
    var tasks: [LastlyTask]
    
    var body: some View {
        Group {
            ForEach(tasks) { task in
                TaskRowView(task: task)
            }
            
            Text("Insert new task")
                .italic()
                .foregroundStyle(Color.red)
        }
    }
}

#Preview {
    TaskListView(tasks: [LastlyTask.sample, LastlyTask.sample, LastlyTask.sample])
}
