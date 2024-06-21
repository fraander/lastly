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
    var addDestination: LastlyTag?
    var showAdd: Bool = true
    
    var body: some View {
        Group {
            ForEach(tasks) { task in
                TaskRowView(task: task)
                    .tag(task)
            }
            
            if showAdd {
                TaskAddBar(destination: addDestination)
            }
        }
    }
}

#Preview {
    List {
        TaskListView(tasks: [LastlyTask.sample, LastlyTask.sample, LastlyTask.sample])
    }
}
